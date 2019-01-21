//
//  LoginVC.swift
//  huberDriver
//
//  Created by Igor-Macbook Pro on 20/01/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC : UIViewController {
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        if let email = emailTF.text, let pass = passwordTF.text {
            Auth.auth().signIn(withEmail: email, password: pass) { [weak self](result, error) in
                if result != nil {
                    self!.performSegue(withIdentifier: "", sender: self)
                }
            }
        }
    }
    
    
    @IBAction func goToRegisterButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "goToRegister", sender: self)
    }
    
}
