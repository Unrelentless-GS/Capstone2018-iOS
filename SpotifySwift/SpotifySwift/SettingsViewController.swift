//
//  SettingsViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 14/10/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var roomCodeLabel: UILabel!
    override func viewDidLoad() {
        
        roomCodeLabel.text=roomCode.uppercased()
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
