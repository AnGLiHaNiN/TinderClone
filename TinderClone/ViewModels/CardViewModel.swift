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

struct CardViewModel{
    let imageNames: [String]
    let attributedString: NSAttributedString
    let textAligment: NSTextAlignment
}
