//
//  LoginViewController+handlers.swift
//  PlayChatInApp
//
//  Created by Chowdhury Md Rajib Sarwar on 3/1/19.
//  Copyright © 2019 Chowdhury Md Rajib Sarwar. All rights reserved.
//

import UIKit
import Firebase

extension LoginViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @objc func handleRegister() {
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid")
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { (user, err) in
            if err != nil {
                print(err as Any)
                return
            }
            
            guard let uid = user?.user.uid else { return }
            
            let imageName = NSUUID().uuidString
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            
            if let profileImage = self.profileImageView.image, let uploadData = profileImage.jpegData(compressionQuality: 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, err) in
                    
                    if err != nil {
                        print(err as Any)
                        return
                    }
                    
                    storageRef.downloadURL(completion: { (imageURL, err) in
                        if err != nil {
                            print(err as Any)
                            return
                        }
                        if imageURL != nil {
                            
                            let values = ["name": name,"email": email, "profileImageUrl": imageURL?.absoluteString]
                            self.registerUserIntoDatabaseWithUID(uid: uid, values: values as [String : AnyObject])
                           
                        }
                    })
                })
            }
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: AnyObject]) {
        let ref = Database.database().reference(fromURL: "https://chatapp-24de8.firebaseio.com/")
        let usersReference = ref.root.child("users").child(uid)
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            
            if err != nil {
                print(err as Any)
                return
            }
            
            let user = User()
            //this setter potentially crashes if keys don't match
            user.name = values["name"] as? String ?? "Test"
            user.email = values["email"] as? String ?? "test@mail.com"
            user.profileImageUrl = values["profileImageUrl"] as? String ?? ""
            
            self.messagesController?.setupNavBarWithUser(user: user)
            self.messagesController?.setupNavBarWithUser(user: user)
            
            print("Saved successfully")
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
}
