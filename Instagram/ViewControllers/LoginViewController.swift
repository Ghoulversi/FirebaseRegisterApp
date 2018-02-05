//
//  LoginViewController.swift
//  Instagram
//
//  Created by Minami on 23.10.17.
//  Copyright © 2017 Minami. All rights reserved.
//

import UIKit
import Firebase
class LoginViewController: UIViewController {

    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwField: UITextField!
  
    
    @IBAction func LoginPressed(_ sender: Any)
    {
        guard emailField.text != "", pwField.text != "" else {return}
        
        Auth.auth().signIn(withEmail: emailField.text!, password: pwField.text!) { (user, error) in
            if let error = error {
               print(error.localizedDescription)
            }
            
            if user != nil {
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "userVC")
                
                self.present(vc, animated: true, completion: nil)
        }
    }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

  

}
