//
//  User.swift
//  TinderClone
//
//  Created by Михаил on 26.02.2023.
//

import Foundation
import UIKit


struct User: ProducesCardViewModel{
    
    var name: String?
    var age: Int?
    var profession: String?
//  let imageNames: [String]
    var imageURL1: String?
    var uid: String?
    
    
    init(dictionary: [String: Any]){
        self.age = dictionary["age"] as? Int
        self.profession = dictionary["profession"] as? String
        self.name = dictionary["fullName"] as? String ?? ""
        self.imageURL1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    
    func toCardViewModel() -> CardViewModel{
        let attribetedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        
        let ageString = age != nil ? "\(age!)" : "N\\A"
        attribetedText.append(NSAttributedString(string: " \(ageString)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        let professionalString = profession != nil ? profession! : "Not available"
        attribetedText.append(NSAttributedString(string: "\n\(professionalString)", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageURL1 ?? ""], attributedString: attribetedText, textAligment: .left)
    }
    
    
}
