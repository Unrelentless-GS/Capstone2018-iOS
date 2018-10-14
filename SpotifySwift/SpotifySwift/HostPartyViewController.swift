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
           // vc?.userHash = self.userHash

            
        }
    }
    
    @IBAction func createPartyBtn(_ sender: Any) {
    if (hostNameTextField.hasText)
    {
        
        hostName = hostNameTextField.text!
        
        let Hostparameters: Parameters = [
            "ImMobile": "ImMobile",
            "Code": authCode,
            "HostNickname": hostNameTextField.text!,
            
            
            ]
        
        print(hostNameTextField.text!)
        
        Alamofire.request("https://spotify-jukebox.viljoen.industries/jukebox.php",method:.post, parameters:Hostparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                if (swiftyJsonVar["JUKE_MSG"].exists())
                {
                    self.partyData = swiftyJsonVar["JUKE_MSG"]
                    userHash = swiftyJsonVar["JUKE_MSG"]["UserHash"].stringValue
                    print(self.partyData)
                    
                    self.performSegue(withIdentifier: "hostParty", sender:nil)
                    
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
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
