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
class InterestPickerViewController: UIViewController, SegueHandlerType {
    
    // MARK: Properties
    enum SegueIdentifier: String {
        case ContinueButtonPressed
        case PinButtonPressed
    }
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var mapButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
            return
        }
        performSegue(withIdentifier: .PinButtonPressed, sender: self)
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
                performSegue(withIdentifier: .ContinueButtonPressed, sender: self)
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
        
        switch segueIdentifierForSegue(segue: segue) {
        case .ContinueButtonPressed:
            deletePins()
        case .PinButtonPressed: break
        }
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
