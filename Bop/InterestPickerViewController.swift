//
//  InterestPickerViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import Crashlytics
import TwitterKit
import DigitsKit

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
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        
        // Remove pins from Core Data
        CoreDataObject.sharedInstance().executePinSearch()
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            for pin in pins {
                AppDelegate.stack.context.delete(pin)
                AppDelegate.stack.save()
            }
        }
        // Remove any Twitter or Digits local session for this app.
        let sessionStore = Twitter.sharedInstance().sessionStore
        if let userId = sessionStore.session()?.userID {
            sessionStore.logOutUserID(userId)
        }
        Digits.sharedInstance().logOut()
        
        // Remove user information for any upcoming crashes in Crashlytics.
        Crashlytics.sharedInstance().setUserIdentifier(nil)
        Crashlytics.sharedInstance().setUserName(nil)
        
        // Log Answers Custom Event.
        Answers.logCustomEvent(withName: "Signed Out", customAttributes: nil)
        
        // Set Guest Login to false
        UserDefaults.standard.set(false, forKey: "guestLoggedIn")
        
        // Present the Login Screen again
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(loginViewController, animated: true, completion: nil)
    }
    
    @IBAction func mapButtonPressed(_ sender: Any) {        
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
                let query = button.queryString(for: InterestButton.Category(rawValue: button.tag)!)
                UserDefaults.standard.set(query, forKey: "Interest")
                performSegue(withIdentifier: .ContinueButtonPressed, sender: self)
            }
        }
    }
    
    // Utilities
    func configureUI() {
        
        for button in interestButtons {
            button.backgroundColor = UIColor.clear
        }
        logoutButton.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Avenir-Light", size: 15)!], for: .normal)
        continueButton.isHidden = true
        CoreDataObject.sharedInstance().executePinSearch()
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin], pins.count > 0 {
            self.mapButton.isEnabled = true
        } else {
            self.mapButton.isEnabled = false
        }
    }
    
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
                print(button.tag)
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
