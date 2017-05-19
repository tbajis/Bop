//
//  InterestPickerViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

// MARK: - InterestPickerViewController: UIViewController
class InterestPickerViewController: UIViewController {
    
    // MARK: Properties
    var isfirstPick = (UserDefaults.standard.object(forKey: "isFirstPick") as? Bool) ?? true
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(named: "bgGradient"), for: .default)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Avenir-Medium", size: 20)!]
        continueButton.isEnabled = false
        
        // Set buttons to red background color
        for button in interestButtons {
            button.backgroundColor = UIColor.red
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin], pins.count > 0 {
            /* TODO: SET BAR BUTTON TO ENABLE IF PINS STORED*/
        }
    }
    
    // MARK: Actions
    /* TODO: CREATE ACTION FOR SAVED INTEREST BUTTON */
    
    @IBAction func interestButtonPressed(_ sender: InterestButton) {
        
        toggleButton(sender, {
            self.updateContinueButton()
        })
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        for button in interestButtons {
            if button.isToggle {
                let query = button.queryString(for: InterestButton.Category(rawValue: sender.tag)!)
                UserDefaults.standard.set(query, forKey: "Interest")
                navigateToTabBarController(with: "continueToTabBar")
                
            }
        }
    }
    
    // Utilities
    func toggleButton(_ sender: InterestButton, _ handler: @escaping () -> Void) {
        
        for button in interestButtons {
            if button == sender {
                button.isToggle = true
            } else {
                button.isToggle = false
            }
        }
        handler()
    }
    
    func updateContinueButton() {
        
        for button in interestButtons {
            if button.isToggle == true {
                self.continueButton.isEnabled = true
            }
        }
    }

    // Helpers
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "continueToTabBar" {
            deletePins()
        }
    }

    func navigateToTabBarController(with identifier: String) {
        performSegue(withIdentifier: identifier, sender: self)
        
    }
    
    func deletePins() {
        
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            for pin in pins {
                AppDelegate.stack.context.delete(pin)
                AppDelegate.stack.save()
            }
        }
    }
}
