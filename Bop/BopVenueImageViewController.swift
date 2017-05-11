//
//  BopVenueImageViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/11/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

class BopVenueImageViewController: UIViewController {
    
    // MARK: Properties
    var itemIndex: Int = 0
    var imageName: String = "" {
        didSet {
            if let imageView = contentImageView {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        contentImageView.image = UIImage(named: imageName)
    }
    
}
