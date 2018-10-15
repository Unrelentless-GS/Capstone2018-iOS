//
//  DevicesViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 12/10/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
var devicesJSON:[JSON] = []

//protocol DeviceTableViewCellDelegate {
//    func didTapDevice(title:String)
//}

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    
    
    let deviceID = ""
    
   // var delegate: DeviceTableViewCellDelegate?

    func setDevicesData(index:Int)
    {
        deviceNameLabel.text = devicesJSON[index]["name"].stringValue
        
    }
}

class DevicesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "dCell", for: indexPath) as! DeviceTableViewCell
        
        
        cell.setDevicesData(index: indexPath.row)
        
        
     //   cell.delegate = self as? DeviceTableViewCellDelegate

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let getDevicesParameters: Parameters = [
            "ImMobile": "ImMobile",
            "Action": "PlayOnDevice",
            "DeviceID": devicesJSON[indexPath.row]["id"].stringValue,
            "JukeboxCookie": userHash,
            ]
        
        
        print(devicesJSON[indexPath.row]["name"])
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/device.php",method:.post, parameters:getDevicesParameters).responseJSON { (responseData) -> Void in
            self.navigationController?.popViewController(animated: true)

            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                
                if (swiftyJsonVar.exists())
                {
                    print(devicesJSON)

                    
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
    
    override func viewDidLoad() {
       update()
        print(userHash)
        super.viewDidLoad()
        tableView.dataSource = self
        
        tableView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print(userHash)

        update()
    }
    
   


  
    func update(){
        let getDevicesParameters: Parameters = [
            "ImMobile": "ImMobile",
            "Action": "GetDevices",
            "JukeboxCookie": userHash,
            ]
        
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/device.php",method:.post, parameters:getDevicesParameters).responseJSON { (responseData) -> Void in
            
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                
                if (swiftyJsonVar.exists())
                {
                    
                    devicesJSON = swiftyJsonVar["devices"].array!
                    
                    
                    print(devicesJSON)
                    self.tableView.reloadData()
                    
                    
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




