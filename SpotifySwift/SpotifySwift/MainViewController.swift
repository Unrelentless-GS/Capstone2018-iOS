//
//  MainViewController.swift
//  SpotifySwift
//
//  Created by Kaz on 10/9/18.
//  Copyright © 2018 Kaz. All rights reserved.
//

import UIKit

class MainViewController: UIViewController{
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        return true
//    }
    

//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // How many rows we need
//        return true
//    }
    
    var partyData:String = ""
    
   // @IBOutlet weak var Test: UILabel!
    override func viewDidLoad() {
        print("NEW SCREEN")
        super.viewDidLoad()
        print(partyData)
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
