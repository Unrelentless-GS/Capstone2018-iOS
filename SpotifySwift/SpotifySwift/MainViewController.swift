//
//  MainViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 10/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

var songs:[UIImage] = []
var songsJSON:[JSON] = []
var searchResults:[JSON] = []
var number = 0
var count = 0

protocol PlaylistTableViewCellDelegate {
    func didTapAddSong(title:String)
    
}

// SECOND CLASS FOR INDIVIDUAL CELLS IN THE TABLE VIEW
class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addSongButton: UIButton!
    var delegate: PlaylistTableViewCellDelegate?
    
  
    var songID:String?

    
    
    @IBAction func addSongBtn(_ sender: Any) {
        delegate?.didTapAddSong(title: songID!)
        
    }
    
    
    // Initalizing the labels that display song name, artist and album image for each cell
    @IBOutlet weak var albumImageLabel: UIImageView!
    
    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    func setResultsData(index: Int){
        
        // Song ID is needed when we are adding a song to the database
        songID=searchResults[index]["id"].stringValue
        // Show Button when search results are shown
        addSongButton.isHidden = false

        
        SongNameLabel.text = searchResults[index]["name"].stringValue
        
        ArtistNameLabel.text = searchResults[index]["artists"][0]["name"].stringValue
        
        albumImageLabel.sd_setImage(with: searchResults[index]["album"]["images"][0]["url"].url, completed: nil)
    }
    
  
    // Function to set the song data to the labels
    func setPlaylistData(index: Int){
        addSongButton.isHidden = true
        SongNameLabel.text = songsJSON[index]["SongName"].stringValue
        ArtistNameLabel.text = songsJSON[index]["SongArtists"].stringValue
        // Use SDWebImage to retrieve Images from URL, NOTE FOR LATER: NEED TO DELETE THE CACHE WHEN DEALING WITH MORE DATA
        albumImageLabel.sd_setImage(with: songsJSON[index]["SongImageLink"].url, completed: nil)

    }
 
}
// MAIN JUKEBOX PLAYLIST PAGE
class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    // TIMER TO UPDATE THE JUKEBOX


    // Bool to see if the search bar is currently searching
    var isSearching = false
    var SearchComplete = false
   
    
    // User Hash
    var userHash:String = ""
    // Function to show how many rows are displayed on the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return 0
        }
        if SearchComplete == true{
            return searchResults.count
        }
        else
        {
        return songsJSON.count
        }
    }
    
    // Creates the indiviudal rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistTableViewCell
        
        // Goes to setPlaylistData function with the current index as parameter (e.g 2)
        
        if SearchComplete == true{

            
            cell.setResultsData(index: indexPath.row)

            //text  = searchResults[indexPath.row]["name"].string
        }
        else
        {
           cell.setPlaylistData(index: indexPath.row)

        }
        
        cell.delegate = self as? PlaylistTableViewCellDelegate
        return cell
    }
    
    
    // Label to show hosts party name e.g. Kaz's Party

    @IBOutlet weak var partyNameTitle: UINavigationItem!
    
    // partyData retrieves data when a user logs in : hosts name, songs already in playlist
    var partyData:JSON = ""
    var timer:Timer? = nil

    override func viewDidLoad() {
        // Verification: If a user hosts a party there wont be any songs in the jukebox
        if !partyData.isEmpty
        {
            songsJSON = partyData["Songs"].array!
        }
        
        //RetrieveImages()
        super.viewDidLoad()
        // Displays hosts party name
        self.partyNameTitle.title = partyData["HostName"].stringValue + "'s Party"
        //initializebutton()
        // Search bar initialize stuff
       searchBar.delegate = self
       // searchBar.returnKeyType = UIReturnKeyType.done
        
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(MainViewController.update), userInfo: nil, repeats: true)

        userHash = partyData["UserHash"].stringValue
        
        // Tableview stuff idk
        tableView.dataSource = self
        

        tableView.delegate = self
       // tableView.dataSource = self
        
        //Retrieves JSON with Song data and saves it into songsJSON
        
        
    
    }
    
    
   // SEARCH BAR
    @IBOutlet weak var searchBar: UISearchBar!

    // Typing in the search bar clears the playlist
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearching = true

        print("Begin Editing")
    }
    
    
   
    // Search bar searching functionality
    func searchBarSearchButtonClicked(_ searchBar1: UISearchBar) {
        isSearching = false
      
            // Post request parameters to search using Spotify
            let Hostparameters: Parameters = [
            "ImMobile": "ImMobile",
            "JukeboxCookie": userHash,
            "Term": searchBar1.text!,
            "Type": "track",
            "Mode": "ImplicitGrant",
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/search.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar2 = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar2.exists())
                {

                    DispatchQueue.main.async{
                        
                        if Thread.isMainThread{
                            searchResults = swiftyJsonVar2["tracks"]["items"].array!

                            self.refreshUI()
                            self.SearchComplete = true



                        }
                        
                        
                    }

                    
                   
                }
                else{
                    // If server authentication fails
                    print(swiftyJsonVar2.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
        
        
       
    }
    
    @objc func update(){
        count  = count + 1
        print(count)
        let HostparametersUpdate: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": "UpdatePlaylist",
            "JukeboxCookie": self.userHash,
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:HostparametersUpdate).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar.exists())
                {
                    
                    
                    DispatchQueue.main.async{
                        
                        if Thread.isMainThread{
                            //print (swiftyJsonVar1)
                            songsJSON = swiftyJsonVar["JUKE_MSG"].array!
                           // print(songsJSON)
                            self.refreshUI()
                            
                            
                        }
                        
                        
                    }
                    
                }
                else{
                    // If server authentication fails
                    print(swiftyJsonVar.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
    }
    
   func refreshUI() {
    DispatchQueue.main.async {
        self.tableView.reloadData()
        
    } }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 


}
extension MainViewController: PlaylistTableViewCellDelegate{
    func didTapAddSong(title: String) {
        
        let Hostparameters: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": "AddSong",
            "SongSpotifyID": title,
            "JukeboxCookie": userHash,
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar.exists())
                {
                    
                    DispatchQueue.main.async{
                        
                        if Thread.isMainThread{
                            print (swiftyJsonVar)
                            //searchResults = swiftyJsonVar["tracks"]["items"].array!
                            print(searchResults[0])
                            //self.refreshUI()
                        
                            
                            let HostparametersUpdate: Parameters = [
                                "ImMobile": "ImMobile",
                                "Operation": "UpdatePlaylist",
                                "JukeboxCookie": self.userHash,
                                ]
                            
                            // Post Request
                            Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:HostparametersUpdate).responseJSON { (responseData) -> Void in
                                if((responseData.result.value) != nil) {
                                    let swiftyJsonVar1 = JSON(responseData.result.value!)
                                    print(swiftyJsonVar1)
                                    //  Verification: If post request returns User Hash (Used to communicate with backend)
                                    if (swiftyJsonVar1.exists())
                                    {
                                        
                                        
                                        DispatchQueue.main.async{
                                            
                                            if Thread.isMainThread{
                                                print (swiftyJsonVar1)
                                                songsJSON = swiftyJsonVar1["JUKE_MSG"].array!
                                                print(songsJSON)
                                                self.refreshUI()
                                                
                                                self.SearchComplete = false
                                                
                                            }
                                            
                                            
                                        }
                                        
                                    }
                                    else{
                                        // If server authentication fails
                                        print(swiftyJsonVar1.error)
                                    }
                                }
                                else
                                {
                                    // If Post requests responds with nil
                                    print(responseData.error)
                                }
                            }
                            
                            
                        }
                        
                        
                    }
                    
                }
                else{
                    // If server authentication fails
                    print(swiftyJsonVar.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
        
       
        
        
        
        
        print(title)
    }
}

