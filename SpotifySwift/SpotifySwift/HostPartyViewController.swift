//
//  HostPartyViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 10/10/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var userHash = ""
var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

class HostPartyViewController: UIViewController {
    var authCode: String = ""
    var hostName = ""
    var partyData:JSON = ""

    @IBOutlet weak var hostNameTextField: UITextField!
    
    
    @IBOutlet weak var createPartyButton: UIButton!
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MainViewController
        {
            let vc = segue.destination as? MainViewController
            vc?.hostName = self.hostName

            
        }
    }
    
    @IBAction func createPartyBtn(_ sender: Any) {
  
    
    if (hostNameTextField.hasText)
    {
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        hostName = hostNameTextField.text!
        
        let Hostparameters: Parameters =
        [
            "ImMobile": "ImMobile",
            "Code": authCode,
            "HostNickname": hostNameTextField.text!,
        ]
        
        
        Alamofire.request("https://spotify-jukebox.viljoen.industries/jukebox.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                

                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar["JUKE_MSG"].exists())
                {
                    self.partyData = swiftyJsonVar["JUKE_MSG"]
                    userHash = swiftyJsonVar["JUKE_MSG"]["UserHash"].stringValue
                    roomCode = swiftyJsonVar["JUKE_MSG"]["JoinCode"].stringValue
                    print(self.partyData)
                    print(userHash)
                    Host = true
                    self.performSegue(withIdentifier: "hostParty", sender:nil)
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                }
                else
                {
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
        else
        {
            let alert = UIAlertController(title: "Cannot Host Party", message: "Please enter a party name.", preferredStyle: UIAlertControllerStyle.alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
                alert.dismiss(animated: true, completion: nil)
                
            }))
            
            self.present(alert,animated: true,completion: nil)
        }
    
    }
    override func viewDidLoad() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.whiteLarge
        view.addSubview(activityIndicator)
        self.navigationController?.isNavigationBarHidden = false
        
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
