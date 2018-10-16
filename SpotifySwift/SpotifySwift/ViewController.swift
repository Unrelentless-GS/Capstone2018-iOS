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
import SafariServices

var Host:Bool = false
class ViewController: UIViewController {
    var authCode = ""

    var partyData:String = ""

    @IBOutlet weak var navBar: UINavigationItem!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is HostPartyViewController
        {
            let vc = segue.destination as? HostPartyViewController
            vc?.authCode = self.authCode

        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        

        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func joinPartyButton(_ sender: UIButton) {
       // let NextView = self.storyboard?.instantiateViewController(withIdentifier: "loginView") as! JoinPartyViewController
        //self.present(NextView, animated: true, completion: nil)
    }
    
    @IBAction func LoginButton(_ sender: UIButton) {
        
        let test = Constants.scope.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        //let test = URL(string:Constants.scope)
        
        
        let authPath =  "https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=\(Constants.code)&scope=\(test!)&utm_source=spotify-sdk&utm_medium=ios-sdk&utm_campaign=ios-sdk&redirect_uri=\(Constants.redirectURI)&show_dialog=true&client_id=\(Constants.clientID)"
        
     //   encodeURIComponent
        print(authPath)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(receievedUrlFromSpotify(_:)),
                                               name: NSNotification.Name.Spotify.authURLOpened,
                                               object: nil)
        // Convert into URL
        if let authURL = URL(string: authPath){
            print(authURL)
            
            if let url = URL(string: authURL.absoluteString) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
              //  vc.delegate = self
                
                present(vc, animated: true)
            }
            
        
                
            
        }
        
        
        
    }
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true)
    }
    
    @objc func receievedUrlFromSpotify(_ notification: Notification) {
        guard let url = notification.object as? URL else { return }
        
      //  print(url)
        
        if (!(url.absoluteString == "jukebox://?error=access_denied"))
        {


        
        //Get the Auth code from URL
        //jukebox://?code=AQD6Zz5gaKeTKMYyMS...
        // Includes redirect uri and auth code
        let components = NSURLComponents(url: url, resolvingAgainstBaseURL: false)
        
        // Remove everything to isolate authcode
        if let range = components?.query?.range(of: "code=") {
            authCode = String((components?.query![range.upperBound...])!)
        }
        self.performSegue(withIdentifier: "hostToJuke", sender:nil)
            dismiss(animated:true)


       
        }
       
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
 

