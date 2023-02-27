//
//  RegistrationViewModel.swift
//  TinderClone
//
//  Created by Михаил on 27.02.2023.
//

import Foundation


class RegistrationViewModel {
    var fullName: String? { didSet{ checkFormValidity()}}
    var email: String? { didSet{ checkFormValidity()}}
    var password: String? { didSet{ checkFormValidity()}}
    
    
    fileprivate func checkFormValidity(){
        let isFormValid = fullName?.isEmpty == false &&
        email?.isEmpty == false &&
        password?.isEmpty == false
        
        isFormValidObserver?(isFormValid)
    }
    
    //Reactive programming
    var isFormValidObserver: ((Bool)->())?
}
