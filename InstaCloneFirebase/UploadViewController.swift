//
//  UploadViewController.swift
//  InstaCloneFirebase
//
//  Created by Александр Федоткин on 29.10.2023.
//

import UIKit
import Firebase

class UploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var commentText: UITextView!
    
 //   @IBOutlet weak var uploadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeImage))
        imageView.addGestureRecognizer(gestureRecognizer)
//        uploadButton.isEnabled = false
        activityIndicator.isHidden = true
        
    }
    
    func makeAlert(titleInput: String, messageInput: String){
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.actionSheet)
        let okButton = UIAlertAction(title: "Ok", style: UIAlertAction.Style.cancel)
        alert.addAction(okButton)
        self.present(alert, animated: true)
    }
    
    @IBAction func uploadClicked(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()

        let storage = Storage.storage()
        let storageReference = storage.reference()
        
        let mediaFolder = storageReference.child("media")
        if let data = imageView.image?.jpegData(compressionQuality: 0.5){
            
            let uuid = UUID().uuidString
            let imageReference = mediaFolder.child("\(uuid).jpg")
            imageReference.putData(data) { metadata, error in
                if error != nil{
                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                } else{
                    imageReference.downloadURL { url, error in
                        if error == nil{
                            let imageURL = url?.absoluteString
                            
                            let firestoreDatebase = Firestore.firestore()
                            var firestoreReferance : DocumentReference? = nil
                            let firestorePost = ["imageUrl" : imageURL!, "postedBy" : Auth.auth().currentUser!.email!, "postComment" : self.commentText.text!, "date" : FieldValue.serverTimestamp(), "likes" : 0] as [String : Any]

                            firestoreReferance = firestoreDatebase.collection("Posts").addDocument(data: firestorePost, completion: { error in
                                if error != nil {
                                    self.makeAlert(titleInput: "Error!", messageInput: error?.localizedDescription ?? "Error!")
                                } else{
                                    self.imageView.image = UIImage.init(systemName: "icloud.and.arrow.down")
                                    self.commentText.text = ""
                                    self.tabBarController?.selectedIndex = 0
                                    self.activityIndicator.stopAnimating()
                                    self.activityIndicator.isHidden = true
                                }
                            })
                        }
                    }
                }
            }
        }
    }
    
    @objc func changeImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        present(picker, animated: true)
  //      uploadButton.isEnabled = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        self.dismiss(animated: true)
    }
}
