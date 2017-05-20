//
//  BopDetailViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/6/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import CoreData

// MARK: BopDetailViewController: UIViewController

class BopDetailViewController: UIViewController {
    
    // MARK: Properties
    var pin: Pin?

    // MARK: Outlets
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var imagePageView: UIView!
    
    // MARK: Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InjectPageViewController" {
            let destinationViewController = segue.destination as! BopPageViewController
            destinationViewController.pin = pin
        }
    }
}
