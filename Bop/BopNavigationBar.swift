//
//  BopNavigationBar.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

// MARK: - BopNavigationBar: UINaivgationBar
class BopNavigationBar: UINavigationBar {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setBackgroundImage(UIImage(named: "bgGradient"), for: UIBarMetrics(rawValue: 0)!)
        self.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Avenir-Medium", size: 20)!]
    }
}
