//
//  Bindable.swift
//  TinderClone
//
//  Created by Михаил on 28.02.2023.
//

import Foundation

class Bindable<T> {
    var value: T? {
        didSet {
            observer?(value)
        }
    }
    
    var observer: ((T?) -> ())?
    
    func bind(observer: @escaping (T?) -> ()){
        self.observer = observer
    }
     
} 
