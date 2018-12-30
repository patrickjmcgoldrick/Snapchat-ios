//
//  ViewSnapViewController.swift
//  Snapchat-ios
//
//  Created by dirtbag on 12/30/18.
//  Copyright © 2018 dirtbag. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase
import SDWebImage

class ViewSnapViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblMessage: UILabel!
    
    var snap: DataSnapshot?
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let snapDictionary = snap?.value as? NSDictionary {
            if let message = snapDictionary["message"] as? String{
                
                if let imageURL = snapDictionary["imageURL"] as? String {
                    
                    lblMessage.text = message
                    
                    if let url = URL(string: imageURL) {
                        imageView.sd_setImage(with: url)
                    }
                    
                    if let imageName = snapDictionary["imageName"] as? String {
                        self.imageName = imageName
                    }
                }
            }
        }
        
    }
    
    // when we leave, delete snap record from database
    // and image from storage
    override func viewWillDisappear(_ animated: Bool) {
        
        if let currentUserUid = Auth.auth().currentUser?.uid {
            if let key = snap?.key {
                
                Database.database().reference()
                    .child("users").child(currentUserUid)
                    .child("snaps").child(key)
                    .removeValue()
                
                Storage.storage().reference()
                    .child("images").child(imageName)
                    .delete(completion: nil)
                
            }
        }
    }
    
}
