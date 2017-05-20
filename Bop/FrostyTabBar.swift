//
//  FrostyTabBar.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

// MARK: - FrostyTabBar: UITabBar
class FrostyTabBar: UITabBar {

    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundImage = UIImage.image(with: UIColor.clear)
        
        let frost = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        frost.frame = bounds
        frost.autoresizingMask = .flexibleWidth
        insertSubview(frost, at: 0)
    }

}
