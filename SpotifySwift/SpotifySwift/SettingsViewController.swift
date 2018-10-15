//
//  SettingsViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 14/10/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class SettingsViewController: UIViewController {

    @IBOutlet weak var chooseDeviceButton: UIButton!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var leavePartyButton: UIButton!
    @IBOutlet weak var roomCodeLabel: UILabel!
    override func viewDidLoad() {
        if (Host)
        {
            self.leavePartyButton.setTitle("End Party", for: .normal)
            
             self.chooseDeviceButton.isHidden = false
            self.settingsLabel.isHidden = false
            
            
        }
        else
        {
            self.chooseDeviceButton.isHidden = true
            self.settingsLabel.isHidden = true

            self.leavePartyButton.setTitle("Leave Party", for: .normal)
        }
        
        roomCodeLabel.text=roomCode.uppercased()
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func leavePartyBtn(_ sender: Any) {
        timer!.invalidate()

        var party = ""
        if (Host)
        {
            party = "EndParty"
        }
        else
        {
            party = "LeaveParty"
        }
        
        let Endparameters: Parameters = [
            "ImMobile": "ImMobile",
            "Operation": party,
            "JukeboxCookie": userHash
            ]
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/update.php",method:.post, parameters:Endparameters).responseJSON { (responseData) -> Void in
            if((responseData.result.value) != nil) {
                let responseJSON = JSON(responseData.result.value!)
                
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                var Results = ""
                if (responseJSON.exists())
                {
                    print(responseJSON)
                    Results = responseJSON["JUKE_MSG"]["Status"].stringValue

                    print(Results)
                    if (Results == "Success")
                    {
                        self.performSegue(withIdentifier: "disbandParty", sender:nil)
                    }
                    else
                    {
                        print("ERROR",Results)
                        
                        
                    }
                 print(responseJSON)
                    
                }
                else{
                    // If server authentication fails
                    print(responseJSON.error)
                }
            }
            else
            {
                // If Post requests responds with nil
                print(responseData.error)
            }
        }
        
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
