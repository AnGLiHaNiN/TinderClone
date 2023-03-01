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
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
    
    init(imageNames: [String], attributedString: NSAttributedString, textAligment: NSTextAlignment) {
        self.imageNames = imageNames
        self.attributedString = attributedString
        self.textAligment = textAligment
    }
    
    fileprivate var imageIndex = 0 {
        didSet{
            let imageURL = imageNames[imageIndex]
//            let image = UIImage(named: imageName)
             
            imageIndexObserver?(imageIndex, imageURL)
        }
    }
    
    //ReactiveProgramming
    var imageIndexObserver: ((Int, String?) -> ())?
    
    func advanceToNextPhoto(){
        imageIndex = min(imageIndex + 1, imageNames.count - 1)
    }
    
    func goToPreviousPhoto(){
        imageIndex = max(imageIndex - 1, 0)
    }
}


