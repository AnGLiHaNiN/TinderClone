//
//  ViewController.swift
//  TinderClone
//
//  Created by Михаил on 23.02.2023.
//

import UIKit

class HomeController: UIViewController {

    
    let buttonsStackView = HomeBottomControlsStackView()
    let topStackView = TopNavigationStackView()
    let cardsDeckView = UIView()
    
    let cardViewModels: [CardViewModel] = {
        let producers = [
            User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
            User(name: "Jane", age: 18, profession: "Teatcher", imageNames: ["jane1", "jane2", "jane3"]),
            Advertiser(title: "Slide Out Menu", brandName: "Lets build that app", posterPhotoName: "slide_out_menu_poster"),
            User(name: "Jane", age: 18, profession: "Teatcher", imageNames: ["jane1", "jane2", "jane3"])
        ] as [ProducesCardViewModel]
        
        let viewModels = producers.map {return $0.toCardViewModel()}
        return viewModels
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        topStackView.settingsButton.addTarget(self, action: #selector(handleSettings), for: .touchUpInside)
        
        setupLayout()
        setupDummyCards()
    }
    
    @objc fileprivate func handleSettings(){
        let registrationController = RegistrationController()
        registrationController.modalPresentationStyle = .fullScreen
        present(registrationController, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
     
    //MARK: - FilePrivate
    
    fileprivate func setupDummyCards(){
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            cardsDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
         
    }
    
    fileprivate func setupLayout() {
        let OverallstackView = UIStackView(arrangedSubviews: [topStackView, cardsDeckView, buttonsStackView])
        OverallstackView.axis = .vertical
        
        view.addSubview(OverallstackView)
        OverallstackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        OverallstackView.isLayoutMarginsRelativeArrangement = true
        OverallstackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        OverallstackView.bringSubviewToFront(cardsDeckView)
    }

}

