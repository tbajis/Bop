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
    var completionHandlerForDismissal: () -> Void = { }
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!

    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        continueButton.isEnabled = false
        
        // Set buttons to red background color
        for button in interestButtons {
            button.backgroundColor = UIColor.red
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    // MARK: Actions
    @IBAction func interestButtonPressed(_ sender: InterestButton) {
        
        toggleButton(sender, {
            self.updateContinueButton()
        })
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        
        for button in interestButtons {
            if button.isToggle {
                let category = String(button.tag)
                let query = button.queryString(for: InterestButton.Category(rawValue: sender.tag)!)
                
                CoreDataObject.sharedInstance().executeInterestSearch()
                guard let interest = CoreDataObject.sharedInstance().fetchedInterestResultsController.fetchedObjects as? [Interest], interest.count == 0 else {
                    print("An error occured: Overwriting Interest")
                    return
                }
                CoreDataObject.sharedInstance().interest = Interest(category: category, query: query, context: AppDelegate.stack.context)
                AppDelegate.stack.save()
                navigateToTabBarController()
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
    func navigateToTabBarController() {
        
        let tabBarController = storyboard?.instantiateViewController(withIdentifier: "MapAndTableTabBarController") as! UITabBarController
        present(tabBarController, animated: true, completion: nil)
    }
    
    func dismissToTabViewController(_ completionHandler: @escaping () -> Void) {
        self.dismiss(animated: true, completion: completionHandler)
    }
}
