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

class JoinPartyViewController: UIViewController {

    @IBOutlet weak var roomCodeLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
   
    @IBOutlet weak var n_nameTextField: UITextField!
    @IBOutlet weak var r_codeTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //Disable auto correct for input values
        n_nameTextField.autocorrectionType = .no
        r_codeTextField.autocorrectionType = .no
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func joinPartyButton(_ sender: UIButton) {
        //If both fields are filled in
        
        if(n_nameTextField.hasText && r_codeTextField.hasText)
        {
            print(n_nameTextField.text)
            print(r_codeTextField.text)

            
            let Joinparameters: Parameters = [
                "ImMobile": "ImMobile",
                "Nickname": n_nameTextField.text,
                "PartyCode": r_codeTextField.text
                ]
            
            Alamofire.request("https://spotify-jukebox.viljoen.industries/join.php",method:.post, parameters:Joinparameters).responseJSON { (responseData) -> Void in
                if((responseData.result.value) != nil) {
                    let swiftyJsonVar = JSON(responseData.result.value!)
                    
                    if(swiftyJsonVar["JUKE_MSG"]["JukeboxFault"].exists())
                    {
                        print("Party does not exist")
                    }
                    
                    if(swiftyJsonVar["JUKE_MSG"]["UserHash"].exists())
                    {
                        let NextView = self.storyboard?.instantiateViewController(withIdentifier: "mView") as! MainViewController
                        self.present(NextView, animated: true, completion: nil)
                        
                        
                        
                    }
                    
                    
                    
                    print(swiftyJsonVar,"USER HASH!@#$")
                    
                    //  Verification: If post request returns User Hash (Used to communicate with backend)
                    if (swiftyJsonVar["JUKE_MSG"].exists())
                    {
                        print("USER HASH EXISTS")
//                        let NextView = self.storyboard?.instantiateViewController(withIdentifier: "mView") as! MainViewController
//                        self.present(NextView, animated: true, completion: nil)
                        
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
            print("Please enter Roomcode and Nick Name")
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
