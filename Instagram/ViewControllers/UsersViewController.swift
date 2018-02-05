//
//  UsersViewController.swift
//  Instagram
//
//  Created by Minami on 27.10.17.
//  Copyright © 2017 Minami. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class UsersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var tableview: UITableView!
    
    var user = [User]()
    @IBAction func logOutPressed(_ sender: Any)
    {
        
    }
    
    func retrieveUsers()
    {
        var ref: DatabaseReference
        
        ref = Database.database().reference()
        let userID = Auth.auth().currentUser?.uid
        
        ref.child("users").child(userID!).queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            let users = snapshot.value as! [String: AnyObject]
       //     self.user.removeAll()
            for (_, value) in users {
                if let uid = value["uid"] as? String {
                    if uid != Auth.auth().currentUser?.uid {
                        let userToShow = User()
                        if let fullName = value["full name"] as? String, let imagePath = value["urlToImage"] as? String {
                            userToShow.fullName = fullName
                            userToShow.imagePath = imagePath
                            
                            userToShow.userID = userID
                            
                            self.user.append(userToShow)
                            print(snapshot)
                        }
                    }
                }
            }
            print(snapshot)
            self.tableview.reloadData()
        })
        ref.removeAllObservers()
    }
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableview.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCell
        
        cell.nameLabel.text = self.user[indexPath.row].fullName
        cell.userID = self.user[indexPath.row].userID
        cell.userImage.downloadImage(from: self.user[indexPath.row].imagePath!)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return user.count 
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        retrieveUsers()
        

    }

  
}





extension UIImageView {
    func downloadImage(from imgURL: String!) {
        let url = URLRequest(url: URL(string: imgURL)!)
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.sync {
                self.image = UIImage(data: data!)
            }
            
        }
        task.resume()
    }
}
