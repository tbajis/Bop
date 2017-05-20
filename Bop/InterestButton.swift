//
//  InterestButton.swift
//  BopAround
//
//  Created by Thomas Manos Bajis on 4/18/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit
@IBDesignable

class InterestButton: UIButton {
    
    // MARK: Properties
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var masksToBounds: Bool = false {
        didSet {
            self.layer.masksToBounds = masksToBounds
        }
    }
    
    enum Category: Int {
        case Sport = 0, Music = 1, Food = 2, Art = 3, Fashion = 4, Culture = 5
    }
    
    var isToggle: Bool = false {
        didSet {
            if isToggle {
                self.backgroundColor = UIColor.gray
            } else {
                self.backgroundColor = UIColor.clear
            }
        }
    }
    
    // MARK: Methods
    func queryString(for buttonType: Category) -> String {
        
        switch buttonType {
        case .Sport:
            return "Sports"
        case .Music:
            return "Music"
        case .Food:
            return "Food"
        case .Art:
            return "Art"
        case .Fashion:
            return "Fashion"
        case .Culture:
            return "Culture"
        }
    }
}
