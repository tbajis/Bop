//
//  SegueHandlerType.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

// MARK: SegueHandlerType (Protocol)

protocol SegueHandlerType {
    
    associatedtype SegueIdentifier: RawRepresentable
}

// MARK: - SegueHandlerType (Protocol Extension)

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {

    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifierForSegue(segue: UIStoryboardSegue) -> SegueIdentifier {
        
        guard let identifier = segue.identifier, let segueIdentifier = SegueIdentifier(rawValue: identifier) else {
            fatalError("Invalid segue identifier: \(segue.identifier).")
        }
        return segueIdentifier
    }
}
