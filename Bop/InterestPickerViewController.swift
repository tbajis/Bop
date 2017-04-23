//
//  InterestPickerViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

class InterestPickerViewController: UIViewController {
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: Properties
    var interest: String?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /* TODO: set up a fetched results request for Interest entity
         if there is a result, check for which interest corresponding button, set it to be highlighted
         set all other buttons not highlighted
         */
        continueButton.isEnabled = false
        for button in interestButtons {
            button.backgroundColor = UIColor.red
        }
    }
    // MARK: Actions
    @IBAction func interestButtonPressed(_ sender: InterestButton) {
        
        for button in interestButtons {
            button.backgroundColor = UIColor.red
            sender.backgroundColor = UIColor.gray
            continueButton.isEnabled = true
        }
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        for button in interestButtons {
            if button.backgroundColor == UIColor.gray {
                let category = button.queryString(for: InterestButton.Category(rawValue: button.tag)!)
                /* TODO: Initialize an instance of managed object Interest */
                /* TODO: PerformSegue */
                print("query: \(category)")
                self.interest = category
                performSegue(withIdentifier: "ShowMapAndTable", sender: self)
            }
        }
    }
    
    // Utilities
    
    // Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowMapAndTable" {
            if let destinationController = segue.destination as? MapAndTableTabBarController {
            destinationController.interest = self.interest
            }
            }
        }
}
