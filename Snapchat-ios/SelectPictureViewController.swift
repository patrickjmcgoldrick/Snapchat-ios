//
//  SelectPictureViewController.swift
//  Snapchat-ios
//
//  Created by dirtbag on 12/28/18.
//  Copyright © 2018 dirtbag. All rights reserved.
//

import UIKit
import FirebaseStorage

class SelectPictureViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tfMessage: UITextField!
    
    var imagePicker: UIImagePickerController?
    var imageAdded = false
    var imageName = "\(NSUUID().uuidString).jpg"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
    }
    
    @IBAction func actionSelectImage(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .photoLibrary
            present(imagePicker!, animated: true, completion: nil)
        }
    }
    
    @IBAction func actionCamera(_ sender: Any) {
        if imagePicker != nil {
            imagePicker?.sourceType = .camera
            present(imagePicker!, animated: true, completion: nil)
        }

    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = image
            imageAdded = true
        }
   
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func actionNext(_ sender: Any) {
   
        if let message = tfMessage.text {
            if imageAdded && message != "" {
                // Upload the image
                let imagesFolder = Storage.storage().reference()
                    .child("images")
                if let image = imageView.image {
                    if let imageData = image.jpegData(compressionQuality: 0.1) {
                        
                        let imagePath = imagesFolder.child(imageName)
                            
                        imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                                
                            if let error = error {
                                print ("imageFolder creation error.")
                                self.presentAlert(alert: error.localizedDescription)
                            } else {
                                // get download URL
                                imagePath.downloadURL(completion: { (downloadURL, error) in
                                    if error != nil {
                                        self.presentAlert(alert: error!.localizedDescription)
                                    } else {
                                        if let url = downloadURL as NSURL? {
                                            print ("Download url - \(url.absoluteString)")
                                            self.performSegue(withIdentifier: "selectReceiverSegue", sender: url.absoluteString)
                                        } else {
                                            self.presentAlert(alert: "Download URL unavailable")
                                        }
                                    }
                                })
                            }
                        }
                        
                    }
                    
                }
                
                
                
            } else {
                // We are missing something
                presentAlert(alert: "You must provide an image and a message for your snap.")
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let downloadURL = sender as? String {
            if let selectVC = segue.destination as? SelectRecipientTableViewController {
                
                selectVC.downloadURL = downloadURL
                selectVC.message = tfMessage.text!
                selectVC.imageName = imageName
            } else {
                print ("not the right VC type.")
            }
        } else {
            print ("DOWNLOAD URL - missing")
        }
    }
    
    func presentAlert(alert: String) {
        
        let alert = UIAlertController(title: "Error", message: alert, preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
