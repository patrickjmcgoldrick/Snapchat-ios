//
//  SelectRecipientTableViewController.swift
//  Snapchat-ios
//
//  Created by dirtbag on 12/29/18.
//  Copyright © 2018 dirtbag. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SelectRecipientTableViewController: UITableViewController {

    var downloadURL = ""
    var message = ""
    var imageName = ""
    
    var users: [User] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Database.database().reference()
            .child("users")
            .observe(.childAdded) { (snapshot) in
                let user = User()
                if let userDictionary = snapshot.value as? NSDictionary {
                    if let email = userDictionary["email"] as? String {
                        user.email = email
                        user.uid = snapshot.key
                        self.users.append(user)
                        self.tableView.reloadData()
                    }
                }
        }
        print (downloadURL)
 
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return users.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = users[indexPath.row].email
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = users[indexPath.row]
        
        if let fromEmail = Auth.auth().currentUser?.email {
            let snap = ["from": fromEmail,
                        "message": message,
                        "imageURL": downloadURL,
                        "imageName": imageName]
            Database.database().reference()
                .child("users").child(user.uid)
                .child("snaps").childByAutoId().setValue(snap)
        
            navigationController?.popToRootViewController(animated: true)
        }
    }

}

class User {
    var email = ""
    var uid = ""
}
