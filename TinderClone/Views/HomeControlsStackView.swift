//
//  HomeControlsStackView.swift
//  TinderClone
//
//  Created by Михаил on 25.02.2023.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    
    let refreshButton = createButton(image: #imageLiteral(resourceName: "3 1"))
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "3 2"))
    let superlikeButton = createButton(image: #imageLiteral(resourceName: "3 3"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "3 4"))
    let specialButton = createButton(image: #imageLiteral(resourceName: "3 5"))
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        [refreshButton, dislikeButton, superlikeButton, likeButton, specialButton].forEach { (button) in
            addArrangedSubview(button)
        }
        
        
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
