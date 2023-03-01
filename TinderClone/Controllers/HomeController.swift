//
//  ViewController.swift
//  TinderClone
//
//  Created by Михаил on 23.02.2023.
//

import UIKit
import Firebase
import FirebaseFirestore
import JGProgressHUD

class HomeController: UIViewController {

    
    let buttomControls = HomeBottomControlsStackView()
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    
    var cardViewModels = [CardViewModel]() //empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        buttomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        
        setupLayout()
        setupFirestireUserCards()
        fetchUsersFromFirestore()
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore(){
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        
        let query = Firestore.firestore().collection("users").order(by: "uid").start(after: [lastFetchedUser?.uid ?? ""]).limit(to: 2)
        query.getDocuments { snapsot, err in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users: \(err)")
                return
            }
            
            snapsot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                self.cardViewModels.append(user.toCardViewModel())
                self.lastFetchedUser = user
                self.setupCardFromUser(user: user)
            })
            
            //self.setupFirestireUserCards()
        }
    }
    
    @objc fileprivate func handleSettings(){
        let settingsController = SettingsController()
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
     
    //MARK: - FilePrivate
    
    fileprivate func setupCardFromUser(user: User){
        let cardView = CardView(frame: .zero)
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
    }
    
    fileprivate func setupFirestireUserCards(){
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
         
    }
    
    fileprivate func setupLayout() {
        view.backgroundColor = .white
        let OverallstackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttomControls])
        OverallstackView.axis = .vertical
        
        view.addSubview(OverallstackView)
        OverallstackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        OverallstackView.isLayoutMarginsRelativeArrangement = true
        OverallstackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        OverallstackView.bringSubviewToFront(cardsDeckView)
    }

}

