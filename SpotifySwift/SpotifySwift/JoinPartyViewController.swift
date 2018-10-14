//
//  JoinPartyViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 12/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var roomCode:String = ""


class JoinPartyViewController: UIViewController {

    @IBOutlet weak var roomCodeLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
   
    @IBOutlet weak var n_nameTextField: UITextField!
    @IBOutlet weak var r_codeTextField: UITextField!
    
    var partyData:JSON = ""

    override func viewDidLoad() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)

        super.viewDidLoad()
        //Disable auto correct for input values
        n_nameTextField.autocorrectionType = .no
        r_codeTextField.autocorrectionType = .no
        
        // Do any additional setup after loading the view.
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is MainViewController
        {
            let vc = segue.destination as? MainViewController
            vc?.partyData = self.partyData
        }
    }
    func createAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
            
        }))
        self.present(alert,animated: true,completion: nil)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func joinPartyButton(_ sender: UIButton) {
        
        
        
        
        if(n_nameTextField.hasText && r_codeTextField.hasText)
        {
            // Post Request Parameters
            let Joinparameters: Parameters = [
                "ImMobile": "ImMobile",
                "Nickname": n_nameTextField.text!,
                "PartyCode": r_codeTextField.text!
                ]
            
            Alamofire.request("https://spotify-jukebox.viljoen.industries/join.php",method:.post, parameters:Joinparameters).responseJSON { (responseData) -> Void in
                print(responseData.result.value)
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if(swiftyJsonVar["JUKE_MSG"]["JukeboxFault"].exists())
                    {
                        self.createAlert(title: "Party Does Not Exist", message: "The room code you have entered is invalid.")
                        
                    }
                    
                    if(swiftyJsonVar["JUKE_MSG"]["UserHash"].exists())
                    {
                        roomCode = self.r_codeTextField.text!
                        self.partyData = swiftyJsonVar["JUKE_MSG"]
                        self.performSegue(withIdentifier: "joinPartySegue", sender:nil)
                        print(swiftyJsonVar,"USER HASH!@#$")
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
              self.createAlert(title: "Cannot Join Party", message: "Please enter both room code and nickname.")
            
        }
        
        
        
    }


}
