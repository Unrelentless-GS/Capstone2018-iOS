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
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    @IBAction func joinPartyButton(_ sender: UIButton) {
        let NextView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! JoinPartyViewController
        self.present(NextView, animated: true, completion: nil)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
//        NotificationCenter.default.addObserver(self,selector: #selector(receievedUrlFromSpotify(_:)),name: NSNotification.Name.Spotify.authURLOpened,object: nil)
        
        let authPath =  "https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=\(Constants.code)&scope=streaming&utm_source=spotify-sdk&utm_medium=ios-sdk&utm_campaign=ios-sdk&redirect_uri=\(Constants.redirectURI)&show_dialog=true&client_id=\(Constants.clientID)"
        
    
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
                    print("USER HASH EXISTS")
                    let NextView = self.storyboard?.instantiateViewController(withIdentifier: "mView") as! MainViewController
                    self.present(NextView, animated: true, completion: nil)

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
    
        
        
        // Close the web view if it exists
        //  spotifyAuthWebView?.dismiss(animated: true, completion: nil)
        
        // Remove the observer from the Notification Center
//        NotificationCenter.default.removeObserver(self,
//                                                  name: NSNotification.Name.Spotify.authURLOpened,
//                                                  object: nil)
//        
        // IF Auth Successfull, Go to next screen
       if(SPTAuth.defaultInstance().session.isValid())
       {
                // The streaming login is asyncronious and will alert us if the user
                // was logged in through a delegate, so we need to implement those methods
                SPTAudioStreamingController.sharedInstance().delegate = self
                SPTAudioStreamingController.sharedInstance().login(withAccessToken: SPTAuth.defaultInstance().session.accessToken)
        
            
        }
        else
       {
        //print("ERROR: AUTH FAILED")
        
        }
    }
    
    
    
    
//    func getKey(){
//        if(!SpotifyAPIManager.sharedInstance.hasOAuthToken()){
//            SpotifyAPIManager.sharedInstance.OAuthCompletionHandler = { (error) -> Void in
//                if let error = error{
//                    print(error)
//
//                }
//            }
//            SpotifyAPIManager.sharedInstance.startOAuthLogin()
//
//
//        }
//    }
    
//    func testKey(){
//
//
//
//
//
//    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayErrorMessage(error: Error) {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Error",
                                                    message: error.localizedDescription,
                                                    preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func successfulLogin() {
        // When changing the UI, all actions must be done on the main thread,
        // since this can be called from a notification which doesn't run on
        // the main thread, we must add this code to the main thread's queue
        
        DispatchQueue.main.async {
            // Present next view controller or use performSegue(withIdentifier:, sender:)
            
            let NextView = self.storyboard?.instantiateViewController(withIdentifier: "mView") as! MainViewController
            self.present(NextView, animated: true, completion: nil)
            
            
        }
    }
    
    
}
extension ViewController: SPTAudioStreamingDelegate {
    func audioStreamingDidLogin(_ audioStreaming: SPTAudioStreamingController!) {
        self.successfulLogin()
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController!, didReceiveError error: Error!) {
        displayErrorMessage(error: error)
    }
}

