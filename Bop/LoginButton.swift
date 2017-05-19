//
//  LoginButton.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/18/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
@IBDesignable

// MARK: - LoginButton: UIButton
class LoginButton: UIButton {

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
}
