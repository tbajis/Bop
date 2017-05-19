//
//  BopNavigationBar.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
@IBDesignable

// MARK: - BopNavigationBar: UINaivgationBar
class BopNavigationBar: UINavigationBar {

    // MARK: Properties
    @IBInspectable var backgroundImage: String = "bgGradient" {
        didSet {
            self.setBackgroundImage(UIImage(named: backgroundImage), for: .default)
        }
    }
    @IBInspectable var titleText: String = "Avenir-Medium" {
        didSet {
            self.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: titleText, size: 20)!]
        }
    }
}
