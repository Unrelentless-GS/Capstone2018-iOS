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

protocol PlaylistTableViewCellDelegate {
    func didTapAddSong(title:String)
    
}

// SECOND CLASS FOR INDIVIDUAL CELLS IN THE TABLE VIEW
class PlaylistTableViewCell: UITableViewCell {
    
    @IBOutlet weak var addSongButton: UIButton!
    var delegate: PlaylistTableViewCellDelegate?
    
  
    

    
    
    @IBAction func addSongBtn(_ sender: Any) {
       
        delegate?.didTapAddSong(title: SongNameLabel.text!)
        
    }
    
    
    // Initalizing the labels that display song name, artist and album image for each cell
    @IBOutlet weak var albumImageLabel: UIImageView!
    
    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    func setResultsData(index: Int){
  
        

        SongNameLabel.text = searchResults[index]["name"].stringValue
        ArtistNameLabel.text = searchResults[index]["artists"][0]["name"].stringValue

        
        albumImageLabel.sd_setImage(with: searchResults[index]["album"]["images"][0]["url"].url, completed: nil)

        print(searchResults[index]["artists"][0]["name"].stringValue)
        
        
        
        

    }
    
  
    // Function to set the song data to the labels
    func setPlaylistData(index: Int){
        addSongButton.isHidden = true
        SongNameLabel.text = songsJSON[index]["SongName"].stringValue
        ArtistNameLabel.text = songsJSON[index]["SongArtists"].stringValue
        // Use SDWebImage to retrieve Images from URL, NOTE FOR LATER: NEED TO DELETE THE CACHE WHEN DEALING WITH MORE DATA
        albumImageLabel.sd_setImage(with: songsJSON[index]["SongImageLink"].url, completed: nil)
        print(songsJSON[index]["SongName"].stringValue)

    }
 
}
// MAIN JUKEBOX PLAYLIST PAGE
class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    // Bool to see if the search bar is currently searching
    var isSearching = false
    var SearchComplete = false

    var userHash:String = ""
    // Function to show how many rows are displayed on the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching{
            return 0
        }
        else if SearchComplete{
            print(searchResults.count,"Search Complete")
            number = searchResults.count
            return searchResults.count
        }
        else
        {
        print("Normal", songsJSON.count)
        number = songsJSON.count
        return songsJSON.count
        }
    }
    
    // Creates the indiviudal rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistTableViewCell
        
        // Goes to setPlaylistData function with the current index as parameter (e.g 2)
        
        if SearchComplete{

            
            cell.setResultsData(index: indexPath.row)

            //text  = searchResults[indexPath.row]["name"].string
        }
        else
        {
           cell.setPlaylistData(index: indexPath.row)

        }
        
        print(number)
        cell.delegate = self as? PlaylistTableViewCellDelegate
        return cell
    }
    
    
    // Label to show hosts party name e.g. Kaz's Party

    @IBOutlet weak var partyNameTitle: UINavigationItem!
    
    // partyData retrieves data when a user logs in : hosts name, songs already in playlist
    var partyData:JSON = ""
//    func initializebutton(){
//        addSongBtn.layer.shadowColor = UIColor.black.cgColor
//        addSongBtn.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
//        addSongBtn.layer.masksToBounds = false
//        addSongBtn.layer.shadowRadius = 1.0
//        addSongBtn.layer.shadowOpacity = 0.5
//        addSongBtn.layer.cornerRadius = addSongBtn.frame.width / 2
//    }
    override func viewDidLoad() {
        if !partyData.isEmpty
        {
            songsJSON = partyData["Songs"].array!
        }
       // tableView.prefetchDataSource = self as! UITableViewDataSourcePrefetching
        
        //RetrieveImages()
        super.viewDidLoad()
        // Displays hosts party name
        self.partyNameTitle.title = partyData["HostName"].stringValue + "'s Party"
        //initializebutton()
        // Search bar initialize stuff
       searchBar.delegate = self
       // searchBar.returnKeyType = UIReturnKeyType.done
        
        
        userHash = partyData["UserHash"].stringValue
        
        // Tableview stuff idk
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
      
            SearchComplete = true
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
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar["tracks"].exists())
                {

                    DispatchQueue.main.async{
                        
                        if Thread.isMainThread{
                            print ("MAIN THREAD")
                            searchResults = swiftyJsonVar["tracks"]["items"].array!
                            print(searchResults[0])
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
        print(title)
    }
}

