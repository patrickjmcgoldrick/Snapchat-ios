//
//  ViewController.swift
//  Snapchat-ios
//
//  Created by dirtbag on 12/28/18.
//  Copyright © 2018 dirtbag. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {

    @IBOutlet weak var tfEmail: UITextField!
    
    @IBOutlet weak var tfPassword: UITextField!
    
    @IBOutlet weak var btnLoginSignup: UIButton!
    
    @IBOutlet weak var btnSwitchLoginSignup: UIButton!
    
    var inLoginMode = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func actionLoginSignup(_ sender: Any) {
        if let email = tfEmail.text {
            if let password = tfPassword.text {
            
                if inLoginMode {
                    // Login
                    Auth.auth().signIn(withEmail: email, password: password) { (authResult, error) in
                        
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            print ("Log in Successful.")
                            self.performSegue(withIdentifier: "loginToSnaps", sender: nil)
                        }
                    }
                 } else {
                    // Signup
                    Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                        
                        if let error = error {
                            self.presentAlert(alert: error.localizedDescription)
                        } else {
                            if let userid = authResult?.user.uid {
                                Database.database().reference()
                                    .child("users")
                                    .child(userid)
                                    .child("email")
                                    .setValue(email)
                                
                                self.performSegue(withIdentifier: "loginToSnaps", sender: nil)
                            }
                        }
                    }

                }
            }
        }
    }
    
    @IBAction func actionSwitchLoginSignup(_ sender: Any) {
        
        if inLoginMode {
            // switch to Signup
            btnLoginSignup.setTitle("Sign Up", for: .normal)
            btnSwitchLoginSignup.setTitle("Switch to Log In", for: .normal)
            inLoginMode = false
        } else {
            // switch to Login
            btnLoginSignup.setTitle("Log In", for: .normal)
            btnSwitchLoginSignup.setTitle("Switch to Sign Up", for: .normal)
            inLoginMode = true
        }
    }
    
    func presentAlert(alert: String) {
        
        let alert = UIAlertController(title: "Error", message: alert, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}

