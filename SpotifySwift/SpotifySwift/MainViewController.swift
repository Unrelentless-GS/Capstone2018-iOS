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
       // albumImageLabel.image = songs[index]
        
      

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
    @IBOutlet weak var partyNameLabel: UILabel!

    
    var partyData:JSON = ""
    
    override func viewDidLoad() {
        songsJSON = partyData["Songs"].array!

        //RetrieveImages()
        super.viewDidLoad()
        print(partyData)
        // Displays hosts party name
        self.partyNameLabel.text = partyData["HostName"].stringValue + "'s Party"
        
        // Tableview stuff idk
        tableView.delegate = self
        tableView.dataSource = self
        
        //Retrieves JSON with Song data and saves it into songsJSON
        
        
        

        
    }
   
    func RetrieveImages(){
        var i=0
        while i<songsJSON.count-1{
            let session = URLSession(configuration: .default)
            
            let getImageFromURL = session.dataTask(with:URL(string: songsJSON[i]["SongImageLink"].stringValue)!){ (data,response,error) in
                if let e = error{
                    print("Couldnt retrieve image\(e)")
                }
                else{
                    if(response as? HTTPURLResponse) != nil{
                        if let imageData = data{
                            let image = UIImage(data: imageData)
                            print(i)
                            songs.insert(image!, at: i)
                        }
                        else{
                            print("No image found")
                        }
                    }
                    else{
                        print("No reponse from server")
                        
                    }
                }
                
            }
            getImageFromURL.resume()
            
            
            i = i + 1
        }
        
        
       
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
