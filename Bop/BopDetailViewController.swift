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
    @IBOutlet weak var venueLabel: UILabel!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation bar to be transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage.image(with: UIColor.clear), for: UIBarMetrics(rawValue: 0)!)
        
        // Set venue label to pin's title
        if let title = pin?.title {
            let mutableTitle = title as NSString
            let newTitle = mutableTitle.replacingOccurrences(of: " " , with: "")
            venueLabel.text = "#\(newTitle)"
        } else {
            venueLabel.text = nil
        }
    }
    
    // MARK: Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "InjectPageViewController" {
            let destinationViewController = segue.destination as! BopPageViewController
            destinationViewController.pin = pin
            destinationViewController.imagePageView = imagePageView
        }
        
        if segue.identifier == "InjectTwitterViewController" {
            let destinationViewController = segue.destination as! BopTwitterViewController
            destinationViewController.pin = pin
        }
    }
}
