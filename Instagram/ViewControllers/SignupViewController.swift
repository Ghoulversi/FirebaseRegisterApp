//
//  SignupViewController.swift
//  Instagram
//
//  Created by Minami on 15.10.17.
//  Copyright © 2017 Minami. All rights reserved.
//

import UIKit
import Firebase

class SignupViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    
    let picker = UIImagePickerController()
    var storage: StorageReference! {
        return Storage.storage().reference().child("users")
    }
    var ref: DatabaseReference! {
        return Database.database().reference()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        picker.delegate = self
        
    }

    @IBAction func selectImagePressed(_ sender: Any)
    {
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage
        {
            self.imageView.image = image
            imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.3
            imageView.clipsToBounds = true
            nextButton.isHidden = false
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func nextPressed(_ sender: Any)
    {
        guard nameField.text != "", emailField.text != "", password.text != "", confirmPassword.text != "" else
        {
            return
        }
        if password.text == confirmPassword.text
        {
            Auth.auth().createUser(withEmail: emailField.text! , password: password.text!, completion: { (user, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                if let user = user
                {
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = self.nameField.text!
                    changeRequest?.commitChanges(completion: nil)
                    
                    let imageRef = self.storage.child("\(user.uid).jpg")
                    let data = UIImageJPEGRepresentation(self.imageView.image!, 0.5)
                    let uploadTask = imageRef.putData(data!, metadata: nil, completion: { (metadata, err) in
                        if err != nil
                        {
                            print(err?.localizedDescription as Any)
                        }
                        
                        imageRef.downloadURL(completion: { (url, er) in
                            if er != nil
                            {
                                print(er?.localizedDescription as Any)
                            }
                            if let url = url
                            {
                                let userInfo: [String : Any] = ["uid" : user.uid,
                                                                "full name": self.nameField.text!,
                                                                "urlToImage": url.absoluteString]
                            
                                self.ref.child("users").child(user.uid).setValue(userInfo)
                                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                                self.present(vc, animated: true, completion: nil)
                            }
                        })
                    }); uploadTask.resume()
                }
            })
          }
          else
        {
            print("Password does not match")
        }
      }
    }
