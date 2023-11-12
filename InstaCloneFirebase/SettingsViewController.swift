//
//  SettingsViewController.swift
//  InstaCloneFirebase
//
//  Created by Александр Федоткин on 29.10.2023.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func logoutClicked(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            performSegue(withIdentifier: "toVC", sender: nil)
        } catch{
            print("error")
        }
    }
    
}
