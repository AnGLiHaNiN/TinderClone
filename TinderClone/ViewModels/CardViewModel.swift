//
//  CardViewModel.swift
//  TinderClone
//
//  Created by Михаил on 26.02.2023.
//

import Foundation
import UIKit

protocol ProducesCardViewModel {
    func toCardViewModel() -> CardViewModel
}

class CardViewModel{
    let uid: String
    let imageUrls: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
    init(uid: String, imageNames: [String], attributedString: NSAttributedString, textAligment: NSTextAlignment) {
        self.uid = uid
        self.imageUrls = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageURL = imageUrls[imageIndex]
//            let image = UIImage(named: imageName)
             
            imageIndexObserver?(imageIndex, imageURL)
        }
    }
    
    //ReactiveProgramming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto(){
        imageIndex = min(imageIndex + 1, imageUrls.count - 1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(imageIndex - 1, 0)
    }
}


