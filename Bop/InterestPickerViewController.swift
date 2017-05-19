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
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.setBackgroundImage(UIImage(named: "bgGradient"), for: .default)
        navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Avenir-Medium", size: 20)!]
        
        // Set buttons to clear background color
        for button in interestButtons {
            button.backgroundColor = UIColor.clear
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        continueButton.isHidden = true
        
        CoreDataObject.sharedInstance().executePinSearch()
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin], pins.count > 0 {
            self.mapButton.isEnabled = true
        } else {
            self.mapButton.isEnabled = false
        }
    }
    
    // MARK: Actions
    @IBAction func mapButtonPressed(_ sender: Any) {
        
        guard let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin], pins.count > 0 else {
            print("THERE ARE NO PINS")
            return
        }
        print("THIS WOULD SEGUE")
        //navigateToTabBarController(with: "continueToTabBar")
    }
    
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
                self.continueButton.isHidden = false
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
