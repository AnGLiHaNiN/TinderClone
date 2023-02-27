//
//  RegistrationController.swift
//  TinderClone
//
//  Created by Михаил on 27.02.2023.
//

import UIKit

class RegistrationController: UIViewController {

    let selectPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        button.backgroundColor = .white
        button.setTitleColor(.black, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        button.layer.cornerRadius = 16
        return button
    }()
    
    let fullNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter full name"
        tf.backgroundColor = .white
        return tf
    }()
    
    let emailNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter email"
        tf.keyboardType = .emailAddress
        tf.backgroundColor = .white
        return tf
    }()
    
    let passwordNameTextField: CustomTextField = {
        let tf = CustomTextField(padding: 24, height: 44)
        tf.placeholder = "Enter password"
        tf.isSecureTextEntry = true
        tf.backgroundColor = .white
        return tf
    }()
    
    let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .heavy)
        button.backgroundColor = #colorLiteral(red: 0.8118591905, green: 0.09407808632, blue: 0.327018857, alpha: 1)
        button.setTitleColor(.white, for: .normal)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 25
        
        return button
    }()
    
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupGradientLayer()
        
        setupLayout()
        setupNotificationsObservers()
 
    }
    
    //MARK: - Private
    
    fileprivate func setupNotificationsObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc fileprivate func handleKeyboardShow(notification: Notification) {
        // how to figure out how tall the keyboard actually is
        guard let value = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = value.cgRectValue
        print(keyboardFrame)
        
        // let's try to figure out how tall the gap is from the register button to the bottom of the screen
        let bottomSpace = view.frame.height - stackView.frame.origin.y - stackView.frame.height
        print(bottomSpace)
        
        let difference = keyboardFrame.height - bottomSpace
        self.view.transform = CGAffineTransform(translationX: 0, y: -difference - 8)
    }
    
    lazy var stackView = UIStackView(arrangedSubviews: [
        selectPhotoButton,
        fullNameTextField,
        emailNameTextField,
        passwordNameTextField,
        registerButton
    ])
    
    fileprivate func setupLayout() {
        
        view.addSubview(stackView)
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 50, bottom: 0, right: 50 ))
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    
    fileprivate func setupGradientLayer(){
        let gradientLayer = CAGradientLayer()
        let topColor = #colorLiteral(red: 1, green: 0.2885035872, blue: 0.3461025953, alpha: 1)
        let bottomColor = #colorLiteral(red: 0.8980392157, green: 0, blue: 0.4470588235, alpha: 1)
        gradientLayer.colors = [topColor.cgColor, bottomColor.cgColor]
        gradientLayer.locations = [0, 1]
        view.layer.addSublayer(gradientLayer)
        gradientLayer.frame = view.bounds
    }
    


}
