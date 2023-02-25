//
//  TopNavigationStackView.swift
//  TinderClone
//
//  Created by Михаил on 25.02.2023.
//

import UIKit

class TopNavigationStackView: UIStackView {

    
    let settingsButton = UIButton(type: .system)
    let messageButton = UIButton(type: .system)
    let fireImageView = UIImageView(image: #imageLiteral(resourceName: "3 7"))
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
         
        fireImageView.contentMode = .scaleAspectFit
        
        settingsButton.setImage(#imageLiteral(resourceName: "3 6").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "3 8").withRenderingMode(.alwaysOriginal), for: .normal)
         
        [settingsButton, UIView(), fireImageView, UIView(), messageButton].forEach { (v) in
            addArrangedSubview(v)
        }
        
        axis = .horizontal
        distribution = .equalCentering
        heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
