//
//  HomeControlsStackView.swift
//  TinderClone
//
//  Created by Михаил on 25.02.2023.
//

import UIKit

class HomeBottomControlsStackView: UIStackView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let subViews = [#imageLiteral(resourceName: "3 1"), #imageLiteral(resourceName: "3 2"), #imageLiteral(resourceName: "3 3"), #imageLiteral(resourceName: "3 4"), #imageLiteral(resourceName: "3 5")].map { (image) -> UIButton in
            let button = UIButton(type: .system)
            button.setImage(image.withRenderingMode(.alwaysOriginal) , for: .normal)
            return button
        }
        
             
        subViews.forEach { (v) in
            addArrangedSubview(v)
        }
        
        axis = .horizontal
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
