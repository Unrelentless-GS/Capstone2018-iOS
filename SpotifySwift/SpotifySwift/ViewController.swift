//
//  ViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 8/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {
    
    var partyData:String = ""

    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MainViewController
        {
            let vc = segue.destination as? MainViewController
            vc?.partyData = "Arthur Dent"
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func joinPartyButton(_ sender: UIButton) {
        let NextView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! JoinPartyViewController
        self.present(NextView, animated: true, completion: nil)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        
        let authPath =  "https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=\(Constants.code)&scope=streaming&utm_source=spotify-sdk&utm_medium=ios-sdk&utm_campaign=ios-sdk&redirect_uri=\(Constants.redirectURI)&show_dialog=true&client_id=\(Constants.clientID)"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receievedUrlFromSpotify(_:)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        // Convert into URL
        if let authURL = URL(string: authPath){
            
            // Open Safari with link
            UIApplication.shared.open(authURL, options: [:], completionHandler:nil)
                
            
        }
        
        
        
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        
        
        
        //Get the Auth code from URL
        //jukebox://?code=AQD6Zz5gaKeTKMYyMS...
        // Includes redirect uri and auth code
        print(url)
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Remove everything to isolate authcode
        var authCode = ""
        if let range = components?.query?.range(of: "code=") {
            authCode = String((components?.query![range.upperBound...])!)
        }
       
    
        
        // POST REQUEST TO SEND AUTH CODE TO CREATE PARTY
        let Hostparameters: Parameters = [
            "ImMobile": "ImMobile",
            "Code": authCode,
            "HostNickname": "TestNickName",
            
            
        ]
        print("BEGIN",authCode,"AUTHCODE")
        
        Alamofire.request("https://spotify-jukebox.viljoen.industries/jukebox.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                print(swiftyJsonVar,"USER HASH!@#$")
                
               //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar["JUKE_MSG"].exists())
                {
                    self.performSegue(withIdentifier: "hostToJuke", sender:nil)

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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
 

