//
//  AgeRangeCell.swift
//  TinderClone
//
//  Created by Михаил on 02.03.2023.
//

import UIKit

class AgeRangeCell: UITableViewCell {
    
    let minSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let maxSlider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 18
        slider.maximumValue = 100
        return slider
    }()
    
    let minLable: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Min 88"
        return label
    }()
    
    let maxLable: UILabel = {
        let label = AgeRangeLabel()
        label.text = "Max 88"
        return label
    }()
    
    class AgeRangeLabel: UILabel {
        override var intrinsicContentSize: CGSize {
            return .init(width: 80, height: 0)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let overallStackView = UIStackView(arrangedSubviews: [
            UIStackView(arrangedSubviews: [minLable, minSlider]),
            UIStackView(arrangedSubviews: [maxLable, maxSlider])
        ])
        
        overallStackView.axis = .vertical
        overallStackView.spacing = 16
        contentView.addSubview(overallStackView)
        overallStackView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: contentView.trailingAnchor, padding: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
