//
//  FeedViewController.swift
//  InstaCloneFirebase
//
//  Created by Александр Федоткин on 29.10.2023.
//

import UIKit
import Firebase
import SDWebImage

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var userEmailArray = [String]()
    var userCommentArray = [String]()
    var likesArray = [Int]()
    var userImageArray = [String]()
    var documentIdArray = [String]()
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getDataFromFirestore()
    }
    
    func getDataFromFirestore(){
        let fireStoreDatabase = Firestore.firestore()
        
        fireStoreDatabase.collection("Posts").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil{
                self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
            } else{
                if snapshot?.isEmpty != nil && snapshot != nil{
                    
                    self.userImageArray.removeAll()
                    self.userEmailArray.removeAll()
                    self.userCommentArray.removeAll()
                    self.likesArray.removeAll()
                    self.documentIdArray.removeAll()
                    for document in snapshot!.documents{
                        let documentID = document.documentID
                        self.documentIdArray.append(documentID)
                        if let postedBy = document.get("postedBy") as? String{
                            self.userEmailArray.append(postedBy)
                        }
                        
                        if let postComment = document.get("postComment") as? String{
                            self.userCommentArray.append(postComment)
                        }
                        
                        if let likes = document.get("likes") as? Int{
                            self.likesArray.append(likes)
                        }
                        
                        if let imageUrl = document.get("imageUrl") as? String{
                            self.userImageArray.append(imageUrl)
                            
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeedCell
        cell.userEmailLable.text = userEmailArray[indexPath.row]
        cell.commentLable.text = userCommentArray[indexPath.row]
        cell.likesLable.text = String(likesArray[indexPath.row])
        cell.userImageView.sd_setImage(with: URL(string: userImageArray[indexPath.row]))
        cell.documentIdLable.text = documentIdArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userEmailArray.count
    }
    

    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let okButtotn = UIAlertAction(title: titleInput, style: UIAlertAction.Style.cancel)
        alert.addAction(okButtotn)
        present(alert, animated: true)
    }
}
