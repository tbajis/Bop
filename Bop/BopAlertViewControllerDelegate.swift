//
//  BopAlertViewControllerDelegate.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/23/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

protocol BopAlertViewControllerDelegate {
    
    func displayError(from hostViewController: UIViewController, with message: String?)
}

extension BopAlertViewControllerDelegate {
    
    func displayError(from hostViewController: UIViewController, with message: String?) {
        
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        hostViewController.present(alertController, animated: true, completion: nil)
    }
}
