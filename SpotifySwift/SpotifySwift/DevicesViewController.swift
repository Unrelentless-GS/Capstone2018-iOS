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
//var userHash:String = ""
var devicesJSON:[JSON] = []

protocol DeviceTableViewCellDelegate {
    func didTapDevice(title:String)
}

class DeviceTableViewCell: UITableViewCell {
    
    @IBOutlet weak var deviceNameLabel: UILabel!
    
    @IBOutlet weak var addDeviceButton: UIButton!
    
    let deviceID = ""
    
    var delegate: DeviceTableViewCellDelegate?

    
    @IBAction func addDeviceBtn(_ sender: Any) {
        delegate?.didTapDevice(title:"Buh")
    }
    
    
    func setDevicesData(index:Int)
    {
        print(devicesJSON[index]["name"].stringValue)
    }
}

class DevicesViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return devicesJSON.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DeviceTableViewCell
        
        
        cell.setDevicesData(index: indexPath.row)
        
        return cell
    }
    
    
    
    override func viewDidLoad() {
        update()
        super.viewDidLoad()
        print("USER HASH", userHash)
        tableView.delegate = self

        // Do any additional setup after loading the view.
    }
    
    
   


  
    func update(){
        print(userHash)
        let getDevicesParameters: Parameters = [
            "ImMobile": "ImMobile",
            "Action": "GetDevices",
            "JukeboxCookie": userHash,
            ]
        
        
        // Post Request
        Alamofire.request("https://spotify-jukebox.viljoen.industries/player.php",method:.post, parameters:getDevicesParameters).responseJSON { (responseData) -> Void in
            print("BUH",responseData.result.value)
            print(responseData)
            if((responseData.result.value) != nil) {
                let swiftyJsonVar = JSON(responseData.result.value!)
                //  Verification: If post request returns User Hash (Used to communicate with backend)
                print(swiftyJsonVar)
                print(responseData.result.value!)
                print(userHash)
                if (swiftyJsonVar.exists())
                {
                    
                    print(swiftyJsonVar)
                    var jsonString = swiftyJsonVar["JUKE_MSG"].rawString()!
                    
                  
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

extension DevicesViewController: DeviceTableViewCellDelegate{
    func didTapDevice(title: String) {
        print(title)
    }
    
    
}


