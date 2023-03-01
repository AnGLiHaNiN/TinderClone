//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Михаил on 27.02.2023.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorage


class RegistrationViewModel {
    
    var bindableImage = Bindable<UIImage>()
    var bindableIsFormValidObserver = Bindable<Bool>()
    var bindableRegestering = Bindable<Bool>()
    
    var fullName: String? { didSet{ checkFormValidity()}}
    var email: String? { didSet{ checkFormValidity()}}
    var password: String? { didSet{ checkFormValidity()}}
    
    func performRegistration(completion: @escaping (Error?) -> ()){
        guard let email = email,  let password = password else {return}
        bindableRegestering.value = true
        Auth.auth().createUser(withEmail: email, password: password) { res, err  in
            if let err = err {
                completion(err)
                return
            }
            print("Successflly registered user:", res?.user.uid ?? "")
            self.saveImageToFirebase(completion: completion)
        }
    }
    
    fileprivate func saveImageToFirebase(completion: @escaping (Error?) -> ()){
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        let imageData = self.bindableImage.value?.jpegData(compressionQuality: 0.75) ?? Data()
        ref.putData(imageData) { (_, err) in
            if let err = err{
                completion(err)
                return
            }
            
            print("Finished uploading image to the storage")
            ref.downloadURL { url, err in
                if let err = err {
                    completion(err)
                    return
                }
                
                self.bindableRegestering.value = false
                print("Downloaded URL for our image is: \(url?.absoluteString ?? "")")
                
                let imageUrl = url?.absoluteString ?? ""
                self.SaviInfoToFirestore(imageUrl: imageUrl, completion: completion)
                completion(nil)
            }
        }
    }
    
    fileprivate func SaviInfoToFirestore(imageUrl: String, completion: @escaping (Error?) -> ()){
        let uid = Auth.auth().currentUser?.uid ?? ""
        let docData = ["fullName": fullName ?? "", "uid": uid, "imageUrl1": imageUrl]
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            if let err = err {
                completion(err)
                return
            }
            completion(nil)
        }
    }
    
    
    fileprivate func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        bindableIsFormValidObserver.value = isFormValid
    }
}
