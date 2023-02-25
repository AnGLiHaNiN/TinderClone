//
//  ViewController.swift
//  TinderClone
//
//  Created by Михаил on 23.02.2023.
//

import UIKit

class ViewController: UIViewController {

    
    let buttonsStackView = HomeBottomControlsStackView()
    let topStackView = TopNavigationStackView()
    
    let blueView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         setupLayout()
    }
     
    //MARK: - FilePrivate
    
    fileprivate func setupLayout() {
        let OverallstackView = UIStackView(arrangedSubviews: [topStackView, blueView, buttonsStackView])
        OverallstackView.axis = .vertical
        
        view.addSubview(OverallstackView)
        OverallstackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
    }

}

