//
//  AppDelegate.swift
//  SpotifySwift
//
//  Created by Kaz on 8/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   
    var window: UIWindow?
    
   
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupSpotify()
        
        return true
    }
    
    
    
    //This function is called when the app is opened by a URL
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        //Check if this URL was sent from the Spotify app or website
        if SPTAuth.defaultInstance().canHandle(url) {
         
            
            //Send out a notification which we can listen for in our sign in view controller
            NotificationCenter.default.post(name: NSNotification.Name.Spotify.authURLOpened, object: url)
            return true
        }
        print("Auth Failed")
        return false
    }
    
    
    func setupSpotify() {
        
        SPTAuth.defaultInstance().clientID = Constants.clientID
        SPTAuth.defaultInstance().redirectURL = URL(string:Constants.redirectURI)!
        SPTAuth.defaultInstance().sessionUserDefaultsKey = Constants.sessionKey
        
        //For this application we just want to stream music, so we will only request the streaming scope
        SPTAuth.defaultInstance().requestedScopes = [Constants.scope]
        
        // Start the player (this is only need for applications that using streaming, which we will use
        // in this tutorial)
        do {
            try SPTAudioStreamingController.sharedInstance().start(withClientId: Constants.clientID)
        } catch {
            fatalError("Couldn't start Spotify SDK")
        }
    }
   

}
extension Notification.Name {
    struct Spotify {
        static let authURLOpened = Notification.Name("authURLOpened")
    }
}

