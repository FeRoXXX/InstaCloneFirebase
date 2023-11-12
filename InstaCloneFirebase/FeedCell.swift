//
//  FeedCell.swift
//  InstaCloneFirebase
//
//  Created by Александр Федоткин on 31.10.2023.
//

import UIKit
import Firebase

class FeedCell: UITableViewCell {

    @IBOutlet weak var userEmailLable: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var likesLable: UILabel!
    
    @IBOutlet weak var commentLable: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var documentIdLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonClicked(_ sender: Any) {
        let firestoreDataBase = Firestore.firestore()
        
        if let likeCounts = Int(likesLable.text!) {
            let likeStore = ["likes" : likeCounts + 1] as [String : Any]
            firestoreDataBase.collection("Posts").document(documentIdLable.text!).setData(likeStore, merge: true)
            
        }
    }

}
