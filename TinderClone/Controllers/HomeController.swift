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

class HomeController: UIViewController, SettingsControllerDelegate, LoginControllerDelegate, CardViewDelegate {
    
    let buttomControls = HomeBottomControlsStackView()
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    
    var cardViewModels = [CardViewModel]() //empty array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        buttomControls.refreshButton.addTarget(self, action: #selector(handleRefresh), for: .touchUpInside)
        buttomControls.likeButton.addTarget(self, action: #selector(handleLike), for: .touchUpInside)
        buttomControls.dislikeButton.addTarget(self, action: #selector(handleDislike), for: .touchUpInside)
        
        setupLayout()
        fetchCurrentUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser == nil{
            let loginController = LoginController()
            loginController.delegate = self
            let navController = UINavigationController(rootViewController: loginController)
            navController.modalPresentationStyle = .fullScreen
            present(navController, animated: true)
        }
    }
    
    func didFinishLoggingIn() {
        fetchCurrentUser()
    }
    
    fileprivate var user: User?
    
    fileprivate func fetchCurrentUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else { return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapshot, err in
            if let err = err{
                print(err)
                return
            }
            
            guard let dictionary = snapshot?.data() else {return}
            self.user = User(dictionary: dictionary)
            
            self.fetchSwipes()
           // self.fetchUsersFromFirestore()
        }
    }
    
    
    var swipes = [String: Int]()
    
    fileprivate func fetchSwipes() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("failed to fetch swipes for currently logged in user: ", error)
                return
            }
            
            print("Swipes:", snapshot?.data() ?? "")
            guard let data = snapshot?.data() as? [String: Int] else {return}
            self.swipes = data
            self.fetchUsersFromFirestore()
        }
    }
    
    @objc fileprivate func handleRefresh(){
        fetchUsersFromFirestore()
    }
    
    var lastFetchedUser: User?
    
    fileprivate func fetchUsersFromFirestore(){
        
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Fetching users"
        hud.show(in: view)
        
        let minAge = user?.minSeekingAge ?? SettingsController.minDefaultAge
        let maxAge = user?.maxSeekingAge ?? SettingsController.maxDefaultAge
        
        let query = Firestore.firestore().collection("users").whereField("age", isGreaterThanOrEqualTo: minAge).whereField("age", isLessThanOrEqualTo: maxAge)
        topCardView = nil
        query.getDocuments { snapsot, err in
            hud.dismiss()
            if let err = err {
                print("Failed to fetch users: \(err)")
                return
            }
            
            var previousCardView: CardView?
            
            snapsot?.documents.forEach({ (documentSnapshot) in
                let userDictionary = documentSnapshot.data()
                let user = User(dictionary: userDictionary)
                let isNotCurrentUser  = user.uid != Auth.auth().currentUser?.uid
                let hasNotSwipedBefore = self.swipes[user.uid!] == nil
                if isNotCurrentUser && hasNotSwipedBefore {
                    let cardView = self.setupCardFromUser(user: user)
                    
                    previousCardView?.nextCardView = cardView
                    previousCardView = cardView
                    
                    if self.topCardView == nil { 
                        self.topCardView = cardView
                    }
                }
            })
            
        }
    }
    
    var topCardView: CardView?
    
    @objc func handleLike(){
        saveSwipeToFirestore(didLike: 1)
        perfornSwipeAnimation(translation: 700, angle: 15)
    }
    
    @objc func handleDislike(){
        saveSwipeToFirestore(didLike: 0)
        perfornSwipeAnimation(translation: -700, angle: -15)
    }
    
    fileprivate func saveSwipeToFirestore(didLike: Int){
        guard let uid = Auth.auth().currentUser?.uid else {return}
        guard let cardUID = topCardView?.cardViewModel.uid else {return}
        
        let documentData = [cardUID: didLike]
        
        
        Firestore.firestore().collection("swipes").document(uid).getDocument { snapshot, error in
            if let error = error {
                print("Failed to fatch swipe document")
                return
            }
            
            if snapshot?.exists == true {
                Firestore.firestore().collection("swipes").document(uid).updateData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data, ", error)
                        return
                    }
                    print("Successefully updated swipe...")
                    self.checkIfMatchExists(cardUID: cardUID)
                }
            } else {
                Firestore.firestore().collection("swipes").document(uid).setData(documentData) { (error) in
                    if let error = error {
                        print("Failed to save swipe data, ", error)
                        return
                    }
                    print("Successefully saved swipe...")
                    self.checkIfMatchExists(cardUID: cardUID)
                }
            }
        }
    }
    
    fileprivate func checkIfMatchExists(cardUID: String){
        print("Detecting match")
        
        Firestore.firestore().collection("swipes").document(cardUID).getDocument { (snapshot, error) in
            if let error = error {
                print("Failed to fetch dovument for card user: ", error)
                return
            }
            
            guard let data = snapshot?.data() else {return}
            print(data)
            
            guard let uid = Auth.auth().currentUser?.uid else {return}
            
            let hasMatched = data[uid] as? Int == 1
            if hasMatched {
                print("Has matched")
                let hud = JGProgressHUD(style: .dark)
                hud.textLabel.text = "Found a match!"
                hud.show(in: self.view)
                hud.dismiss(afterDelay: 4)
            }
        }
    }
    
    func removeCardView(cardView: CardView) {
        self.topCardView?.removeFromSuperview()
        self.topCardView = self.topCardView?.nextCardView
    }
    
    
    fileprivate func perfornSwipeAnimation(translation: CGFloat, angle: CGFloat){
        let duration = 0.5
        let translationAnimation = CABasicAnimation(keyPath: "position.x")
        translationAnimation.toValue = translation
        translationAnimation.duration = duration
        translationAnimation.fillMode = .forwards
        translationAnimation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        translationAnimation.isRemovedOnCompletion = false
        
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        
        rotationAnimation.toValue = angle * CGFloat.pi / 180
        rotationAnimation.duration = duration
        
        let cardView = topCardView
        topCardView = topCardView?.nextCardView
        
        CATransaction.setCompletionBlock {
            cardView?.removeFromSuperview()
        }
        
        cardView?.layer.add(translationAnimation, forKey: "translation")
        cardView?.layer.add(rotationAnimation, forKey: "rotation")
        
        CATransaction.commit()
    }
    
    @objc fileprivate func handleSettings(){
        let settingsController = SettingsController()
        settingsController.delegate = self
        let navController = UINavigationController(rootViewController: settingsController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }
    
    func didSaveSattings() {
        print("Notified of dismiss from SettingsController in HomeController")
        fetchCurrentUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
     
    //MARK: - FilePrivate
    
    fileprivate func setupCardFromUser(user: User) -> CardView{
        let cardView = CardView(frame: .zero)
        cardView.delegate = self
        cardView.cardViewModel = user.toCardViewModel()
        cardsDeckView.addSubview(cardView)
        cardsDeckView.sendSubviewToBack(cardView)
        cardView.fillSuperview()
        return cardView
    }
    
    func didTapMoreInfo(cardViewModel: CardViewModel) {
        let userDetailsController = UserDetailsController()
        userDetailsController.modalPresentationStyle = .fullScreen
        userDetailsController.cardViewModel = cardViewModel
        present(userDetailsController, animated: true)
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

