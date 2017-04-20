//
//  InterestButton.swift
//  BopAround
//
//  Created by Thomas Manos Bajis on 4/18/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

class InterestButton: UIButton {
    
    // MARK: Properties
    enum Category: Int {
        case Sport = 0, Music = 1, Food = 2, Art = 3, Fashion = 4, Culture = 5
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
