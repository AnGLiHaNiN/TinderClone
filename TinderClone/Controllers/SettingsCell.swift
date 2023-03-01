//
//  SettingsCell.swift
//  TinderClone
//
//  Created by Михаил on 01.03.2023.
//

import UIKit

class SettingsCell: UITableViewCell, UITextFieldDelegate {
    
    class SettingsTextField: UITextField{
        
        override func textRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override func editingRect(forBounds bounds: CGRect) -> CGRect {
            return bounds.insetBy(dx: 24, dy: 0)
        }
        
        override var intrinsicContentSize: CGSize{
            return .init(width: 0, height: 44)
        }
    }
    
    let textField: SettingsTextField = {
        let tf = SettingsTextField()
        return tf
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(textField)
        //addSubview(textField)
        textField.fillSuperview()
        textField.delegate = self
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
            return true
        }
    
     
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
