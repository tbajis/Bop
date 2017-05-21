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
    var imageName: UIImage = UIImage(named: "detailPlaceholder")! {
        didSet {
            if let imageView = contentImageView {
                imageView.image = imageName
            }
        }
    }
    
    // MARK: Outlets
    @IBOutlet weak var contentImageView: UIImageView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imageName == UIImage(named: "detailPlaceholder") {
            contentImageView.contentMode = UIViewContentMode.scaleAspectFill
        }
        let screenSize: CGRect = UIScreen.main.bounds
        contentImageView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: imageName.size.height)
        contentImageView.image = imageName
    }    
}
