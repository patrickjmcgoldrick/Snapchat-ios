//
//  SnapsTableViewController.swift
//  Snapchat-ios
//
//  Created by dirtbag on 12/28/18.
//  Copyright © 2018 dirtbag. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SnapsTableViewController: UITableViewController {

    var snaps: [DataSnapshot] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let currentUserUid = Auth.auth().currentUser?.uid {
            // Load snaps
            Database.database().reference()
                .child("users").child(currentUserUid)
                .child("snaps")
                .observe(.childAdded) { (snapshot) in
                    self.snaps.append(snapshot)
                    self.tableView.reloadData()
            }
            
            // Delete removed snaps
            Database.database().reference()
                .child("users").child(currentUserUid)
                .child("snaps")
                .observe(.childRemoved) { (snapshot) in

                    var index = 0
                    for snap in self.snaps {
                        if snapshot.key == snap.key {
                            self.snaps.remove(at: index)
                        }
                        index += 1
                    }
                    self.tableView.reloadData()
            }
        }
    }

    @IBAction func actionLogout(_ sender: Any) {
        try? Auth.auth().signOut()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if snaps.count == 0 {
            return 1
        } else {
            return snaps.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        //tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...
        
        if snaps.count == 0 {
            cell.textLabel!.text = "You have no snaps...😔"
            
        } else {
            let snap = snaps[indexPath.row]

            if let snapDictionary = snap.value as? NSDictionary {
                let fromEmail = snapDictionary["from"]
                
                cell.textLabel!.text = fromEmail as? String
        
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let snap = snaps[indexPath.row]

        self.performSegue(withIdentifier: "viewSnapSegue", sender: snap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewSnapSegue" {
            if let viewVC = segue.destination as? ViewSnapViewController {
                
                if let snap =  sender as? DataSnapshot {
                    viewVC.snap = snap
                }
            }
        }
    }
 

   
 





}
