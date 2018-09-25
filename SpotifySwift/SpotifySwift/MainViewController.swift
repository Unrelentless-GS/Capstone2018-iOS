//
//  MainViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 10/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import SwiftyJSON


var songs:[UIImage] = []
var songsJSON:[JSON] = []

// SECOND CLASS FOR INDIVIDUAL CELLS IN THE TABLE VIEW
class PlaylistTableViewCell: UITableViewCell {
    
// Initalizing the labels that display song name, artist and album image
    @IBOutlet weak var albumImageLabel: UIImageView!
    
    @IBOutlet weak var ArtistNameLabel: UILabel!
    
    @IBOutlet weak var SongNameLabel: UILabel!
  
    
    // Function to set the song data to the labels
    func setPlaylistData(index: Int){
        
        print(index)
        SongNameLabel.text = songsJSON[index]["SongName"].stringValue
        ArtistNameLabel.text = songsJSON[index]["SongArtists"].stringValue
        // Use SDWebImage to retrieve Images from URL, NOTE FOR LATER: NEED TO DELETE THE CACHE WHEN DEALING WITH MORE DATA
        albumImageLabel.sd_setImage(with: songsJSON[index]["SongImageLink"].url, completed: nil)
        

        
    }
 
}
class MainViewController: UIViewController, UITableViewDelegate,UITableViewDataSource{
    @IBOutlet weak var tableView: UITableView!
    // Function to show how many rows are needed
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songsJSON.count
    }
    // Creates the indiviudal rows
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! PlaylistTableViewCell
        
        // Goes to setPlaylistData function with the current index as parameter (e.g 2)
        cell.setPlaylistData(index: indexPath.row)
        
        
        return cell
    }
    
    
    // Label to show hosts party name e.g. Kaz's Party

    @IBOutlet weak var partyNameTitle: UINavigationItem!
    var partyData:JSON = ""
    
    override func viewDidLoad() {
        songsJSON = partyData["Songs"].array!
       // tableView.prefetchDataSource = self as! UITableViewDataSourcePrefetching

        //RetrieveImages()
        super.viewDidLoad()
        print(partyData)
        // Displays hosts party name
    
        
            self.partyNameTitle.title = partyData["HostName"].stringValue + "'s Party"
        
        // Tableview stuff idk
        tableView.delegate = self
        tableView.dataSource = self
        
        //Retrieves JSON with Song data and saves it into songsJSON
        
        
        

        
    }
   // SEARCH BAR
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}

//extension ViewController: UITableViewDataSourcePrefetching {
//    public func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
//        let urls = indexPaths.map { baseURL.appendingPathComponent(images[$0.row]) }
//        SDWebImagePrefetcher.shared().prefetchURLs(urls)
//    }
//}
