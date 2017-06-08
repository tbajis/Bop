//
//  LoginViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import TwitterKit
import DigitsKit
import Crashlytics

// MARK: - LoginViewController: UIViewController

class LoginViewController: UIViewController {

    // MARK: Outlets
    
    @IBOutlet weak var loginTwitterButton: UIButton!
    @IBOutlet weak var loginPhoneButton: UIButton!
    @IBOutlet weak var loginGuestButton: UIButton!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureButton()
    }
    
    // MARK: Actions
    
    @IBAction func loginWithTwitter(_ sender: UIButton) {
        
        // Create an instance of a twitter session.
        Twitter.sharedInstance().logIn { session, error in
            if session != nil {
                performUIUpdatesOnMain {
                    // Navigate to the main app screen to select interests.
                    self.navigateToInterestPicker()
                }
                
                // Tie crashes to a Twitter user ID and username in Crashlytics.
                Crashlytics.sharedInstance().setUserIdentifier(session!.userID)
                Crashlytics.sharedInstance().setUserName(session!.userName)
                
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Twitter", success: true, customAttributes: ["User ID": session!.userID])
            } else {
                
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Twitter", success: false, customAttributes: ["Error": error!.localizedDescription])
            }
        }
    }
    
    @IBAction func loginWithPhone(_ sender: UIButton) {
        
        // Create a custom appearance for Digits theme
        let configuration = DGTAuthenticationConfiguration(accountFields: .defaultOptionMask)
        configuration?.appearance = DGTAppearance()
        configuration?.appearance.backgroundColor = UIColor.white
        configuration?.appearance.accentColor = UIColor.yellow
        
        // Start Digits authentication flow
        Digits.sharedInstance().authenticate(with: nil, configuration: configuration!) { (session, error) in
            if session != nil {
                performUIUpdatesOnMain {
                    // Navigate to the main app to select intersts.
                    self.navigateToInterestPicker()
                }
                
                // Tie crashes to a Digits user ID in Crashlytics.
                Crashlytics.sharedInstance().setUserIdentifier(session?.userID)
                
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Digits", success: true, customAttributes: ["User ID": session?.userID as Any])
                
            } else {
                // Log Answers Custom Event.
                Answers.logLogin(withMethod: "Digits", success: false, customAttributes: ["Error": error?.localizedDescription as Any])
            }
        }
    }

    @IBAction func loginAsGuest(_ sender: UIButton) {
        
        // Log Answers Custom Event.
        Answers.logCustomEvent(withName: "Logged In as Guest", customAttributes: nil)
        UserDefaults.standard.set(true, forKey: "guestLoggedIn")
        navigateToInterestPicker()
    }
    
    // MARK: Utilities
    
    func configureButton() {
        loginPhoneButton.tintColor = UIColor.yellow
    }
    
    // MARK: Helpers 
    
    func navigateToInterestPicker() {
        performSegue(withIdentifier: "showInterestPicker", sender: self)
    }
}
