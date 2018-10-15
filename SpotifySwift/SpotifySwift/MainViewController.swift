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
var currentlyPlayingJSON:[JSON] = []

var searchResults:[JSON] = []
var pressPlay:Bool = false

var timer:Timer? = nil

protocol PlaylistTableViewCellDelegate {
    func didTapAddSong(title:String)
    func didTapVote(title:JSON, voted:String, direction: String)
}

// SECOND CLASS FOR INDIVIDUAL CELLS IN THE TABLE VIEW
class PlaylistTableViewCell: UITableViewCell {
    

    @IBOutlet weak var upVoteButton: UIButton!
    @IBOutlet weak var downVoteButton: UIButton!
    
    @IBOutlet weak var addSongButton: UIButton!
    var delegate: PlaylistTableViewCellDelegate?
    var alreadyVoted:String = ""
    var songID:String?
    var ID:Int = 0

    
    
    @IBAction func addSongBtn(_ sender: Any) {
        delegate?.didTapAddSong(title: songID!)
        
    }
    
    
    @IBAction func upVoteBtn(_ sender: Any) {
        delegate?.didTapVote(title :songsJSON[ID], voted:alreadyVoted,direction: "Up")

    }
    
    @IBAction func downVoteBtn(_ sender: Any) {
        delegate?.didTapVote(title :songsJSON[ID], voted:alreadyVoted, direction: "Down")

    }
    
    // Initalizing the labels that display song name, artist and album image for each cell
    @IBOutlet weak var albumImageLabel: UIImageView!

    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    @IBOutlet weak var voteCount: UILabel!
    
    @IBOutlet weak var SongNameLabel: UILabel!
    
    func setResultsData(index: Int){
        upVoteButton.isHidden = true
        downVoteButton.isHidden = true
        songID=searchResults[index]["id"].stringValue
        
        addSongButton.isHidden = false
        
        voteCount.isHidden = true
        
        SongNameLabel.text = searchResults[index]["name"].stringValue
        
        ArtistNameLabel.text = searchResults[index]["artists"][0]["name"].stringValue
        
        albumImageLabel.sd_setImage(with: searchResults[index]["album"]["images"][0]["url"].url, completed: nil)

        
        
    
    }
   
  
    // Function to set the song data to the labels
    func setPlaylistData(index: Int){
        upVoteButton.setImage(UIImage(named: "upvote")?.withRenderingMode(.alwaysOriginal), for: .normal)

        ID = index
        addSongButton.isHidden = true
        upVoteButton.isHidden = false
        downVoteButton.isHidden = false
        voteCount.text = songsJSON[index]["VoteCount"].stringValue
       
        voteCount.isHidden = false
        if (songsJSON[index]["YourVote"].intValue == 1)
        {
            upVoteButton.setImage(UIImage(named: "upvoteGreen")?.withRenderingMode(.alwaysOriginal), for: .normal)
            downVoteButton.setImage(UIImage(named: "downvote")?.withRenderingMode(.alwaysOriginal), for: .normal)

        }
        if(songsJSON[index]["YourVote"].intValue == 0)
        {
            upVoteButton.setImage(UIImage(named: "upvote")?.withRenderingMode(.alwaysOriginal), for: .normal)
            downVoteButton.setImage(UIImage(named: "downvote")?.withRenderingMode(.alwaysOriginal), for: .normal)

        }
        if(songsJSON[index]["YourVote"].intValue == -1)
        {
            downVoteButton.setImage(UIImage(named: "downvoteRed")?.withRenderingMode(.alwaysOriginal), for: .normal)
            upVoteButton.setImage(UIImage(named: "upvote")?.withRenderingMode(.alwaysOriginal), for: .normal)

        }
        
            
        SongNameLabel.text = songsJSON[index]["SongName"].stringValue
        songID = songsJSON[index]["SongSpotifyID"].stringValue

        ArtistNameLabel.text = songsJSON[index]["SongArtists"].stringValue
        // Use SDWebImage to retrieve Images from URL, NOTE FOR LATER: NEED TO DELETE THE CACHE WHEN DEALING WITH MORE DATA
        albumImageLabel.sd_setImage(with: songsJSON[index]["SongImageLink"].url, completed: nil)

    }
 
}
// MAIN JUKEBOX PLAYLIST PAGE
class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var navBar: UINavigationItem!
    // Bool to see if the search bar is currently searching
    var SearchComplete = false
    var hostName = ""
    // Label to show hosts party name e.g. Kaz's Party
    @IBOutlet weak var partyNameTitle: UINavigationItem!
    
    // Labels and Buttons for Currently Playing
    @IBOutlet weak var playingSongName: UILabel!
    @IBOutlet weak var playingSongArtist: UILabel!
    @IBOutlet weak var playingSongImage: UIImageView!
    @IBOutlet weak var startPartyButton: UIButton!
    var isPlaying = false
    var roomCode:String = ""
    var number = 0


//toDevices
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is DevicesViewController
        {
            let vc = segue.destination as? DevicesViewController
         //   vc?.userHash = self.userHash
         
        }
    }
    var partyData:JSON = ""
    
    // User Hash
    //var userHash:String = ""
    // Function to show how many rows are displayed on the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if SearchComplete == true{
            return searchResults.count
        }
        else
        {
        return songsJSON.count
        }
    }
    // Adds song to jukebox when cell is clicked
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(SearchComplete)
        {
            didTapAddSong(title: searchResults[indexPath.row]["id"].stringValue)
        }
    }
    
    // Creates the indiviudal rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistTableViewCell
    
        if SearchComplete == true{
            cell.setResultsData(index: indexPath.row)
        }
        else
        {
           cell.setPlaylistData(index: indexPath.row)
        }
        
        cell.delegate = self as? PlaylistTableViewCellDelegate
        return cell
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.setShowsCancelButton(false, animated: true)
        searchBar.text=""
        SearchComplete = false
        self.refreshUI()
        searchBar.resignFirstResponder()
    }
    
    
    
    // partyData retrieves data when a user logs in : hosts name, songs already in playlist
 
    override func viewDidLoad() {
        if !partyData.isEmpty
        {
            if(!(partyData["Songs"].stringValue == "NoSongsAdded")){
                songsJSON = partyData["Songs"].array!
            }
        }
        if (hostName == "")
        {
            self.navBar.title = partyData["HostName"].stringValue + "'s Party"
        }
        else
        {
            self.navBar.title = hostName + "'s Party"
        }
        
        if(Host)
        {
            startPartyButton.isHidden = false
        }
        else
        {
            startPartyButton.isHidden = true
            
        }
        update()
        self.navigationItem.setHidesBackButton(true, animated:true);

         self.navigationController?.setNavigationBarHidden(false, animated: true)
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navBar.backBarButtonItem = backItem
        // Displays hosts party name
    
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        
        super.viewDidLoad()
     
        
       searchBar.delegate = self
        
        timer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MainViewController.update), userInfo: nil, repeats: true)

     
        // Initalize tableview for data population
        tableView.dataSource = self
    
        tableView.delegate = self
        
    }
   // SEARCH BAR
    @IBOutlet weak var searchBar: UISearchBar!


    // Shows cancel button when searching
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
   
    // SEARCHING: Post request to get data and displays on table view
    func searchBarSearchButtonClicked(_ searchBar1: UISearchBar) {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
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
                let searchbarJSON = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (searchbarJSON.exists())
                {
    
                            searchResults = searchbarJSON["tracks"]["items"].array!
                            self.refreshUI()
                            self.SearchComplete = true
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    
                    
                }
                else{
                    // If server authentication fails
                    print(searchbarJSON.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
    }
    
    
    @IBAction func playBtn(_ sender: Any) {
        
       startParty()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if(pressPlay)
        {
            startParty()
            pressPlay = false
        }
    }

    // Updates the content of the Jukebox, Runs periodically or after every main function call
    @objc func update(){
        let updateParameters: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": "UpdatePlaylist",
            "JukeboxCookie": userHash,
            ]
        
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:updateParameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let updateJSON = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (updateJSON.exists())
                {
                        if Thread.isMainThread{
                            if (!(updateJSON["JUKE_MSG"].stringValue == "NoSongsAdded"))
                            {
                                songsJSON = updateJSON["JUKE_MSG"].array!
                               // userHash = updateJSON["JUKE_MSG"]["UserHash"].stringValue
                                self.refreshUI()
                            }
                            else
                            {
                                songsJSON = []
                                self.refreshUI()

                            }
                        }
                    
                    
                }
                else{
                    // If server authentication fails
                    print("fail 1 ")
                    print(updateJSON.error)
                }
            }
            else
            {
             
          
                    self.performSegue(withIdentifier: "disband", sender:nil)

                    self.createAlert(title: "Lost Connection to Jukebox ", message: "Your connection to the host has been lost, either the Jukebox party has been disbanded or you have internet connenctivity issues.")
                        timer!.invalidate()

                

              
                
                
                
            }
        }
        
        let CurrentPlaybackparametersUpdate: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": "CurrentlyPlaying",
            "JukeboxCookie": userHash,
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:CurrentPlaybackparametersUpdate).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let playbackJSON = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (playbackJSON.exists())
                {
                   var jsonString = playbackJSON["JUKE_MSG"].rawString()!
                    let responseJSON = jsonString.data(using: String.Encoding.utf8).flatMap({try? JSON(data: $0)}) ?? JSON(NSNull())
                    
                    self.playingSongName.text = responseJSON["item"]["name"].rawString()!
                    
                    self.playingSongArtist.text=responseJSON["item"]["artists"][0]["name"].rawString()!
                    
                    self.playingSongImage.sd_setImage(with: responseJSON["item"]["album"]["images"][0]["url"].url, completed: nil)
                    
                    self.isPlaying = responseJSON["is_playing"].boolValue
                    if(self.isPlaying)
                    {
                        //self.startPartyButton.setTitle("Pause", for: .normal)
                        self.startPartyButton.setImage(UIImage(named: "pause"), for: .normal)
                    }
                    else
                    {
                        //self.startPartyButton.setTitle("Play", for: .normal)
                        self.startPartyButton.setImage(UIImage(named: "play"), for: .normal)
                    }
                    
                    if (!self.isPlaying)
                    {
                        self.playingSongName.text = "Not Playing"
                        
                        self.playingSongArtist.text = ""
                    }
                    
                    
                    self.refreshUI()
                }
                else{
                    // If server authentication fails
                    print(playbackJSON.error)
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
    
    
    // Begin playing music, if no device is currently selected goes to choose device page
    func startParty(){
        let getDevicesParameters: Parameters = [
            "ImMobile": "ImMobile",
            "JukeboxCookie": userHash,
            ]
        
        
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/player.php",method:.post, parameters:getDevicesParameters).responseString { (responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                let beginplaylistJSON = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                self.update()
                
                
                if (beginplaylistJSON.exists())
                {
                    if (beginplaylistJSON == "NoDeviceSelected")
                    {
                        
                        pressPlay = true
                        self.performSegue(withIdentifier: "toDevices", sender:nil)
                        
                        
                    }
                    
                }
                else{
                    // If server authentication fails
                    print(beginplaylistJSON.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == ""{
            SearchComplete = false
            tableView.reloadData()
        }
        
    
    }
    
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert,animated: true,completion: nil)
        
    }

}
extension MainViewController: PlaylistTableViewCellDelegate{
 
    func didTapAddSong(title: String) {
       
        
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        self.searchBar.setShowsCancelButton(false, animated: true)

        let addParameters: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": "AddSong",
            "SongSpotifyID": title,
            "JukeboxCookie": userHash,
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:addParameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let addSongJSON = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (addSongJSON.exists())
                {
                    self.SearchComplete = false
                    self.update()
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()


                }
                else{
                    // If server authentication fails
                    print(addSongJSON.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
        }
    
    func didTapVote(title: JSON, voted:String, direction: String) {
        
        var value:Int = 0
        let yourVote = title["YourVote"].intValue
        
      
        // Upvote/Downvote
        if (yourVote == 0 && direction == "Up")
        {
            value = 1
            
            
        }
        else if (yourVote == 0 && direction == "Down")
        {
            value = -1
        }
        else if (yourVote == 1 && direction == "Up")
        {

            value = 0
        }
        else  if (yourVote == 1 && direction == "Down")
        {
            value = -1
        }
        else  if (yourVote == -1 && direction == "Down")
        {
            value = 0
        }
        else if (yourVote == -1 && direction == "Up")
        {
           // button.setImage(UIImage(named: "upvoteGreen")?.withRenderingMode(.alwaysOriginal), for: .normal)
            value = 1
        }
        
        
    
        
        let Hostparameters: Parameters = [
            "ImMobile": "ImMobile",
            "Action": "Voting",
            "SongID": title["SongID"].stringValue,
            "Value":value,
            "JukeboxCookie": userHash,
            
            ]
        
        Alamofire.request("https://spotify-jukebox.viljoen.industries/vote.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar1 = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar1.exists())
                {
                    
                    self.update()
                    
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

