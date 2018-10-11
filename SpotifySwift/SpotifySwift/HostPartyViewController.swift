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

class HostPartyViewController: UIViewController {
    var authCode: String = ""
    var hostName = ""
    
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
