//
//  ViewController.swift
//  GetHospital
//
//  Created by Chaithra Shrikrishna on 14/07/20.
//  Copyright © 2020 Chaithra Shrikrishna. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn

class ViewController: UIViewController {

    @IBOutlet weak var signInButtonObj: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance().presentingViewController = self
    }

    @IBAction func signInClicked(_ sender: UIButton) {
        GIDSignIn.sharedInstance()?.signIn()
        goToHomePage()
    }
    
    func goToHomePage() {
        if let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SearchResultTableViewController") as? SearchResultTableViewController {
            vc.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
