//
//  BopMapViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

class BopMapViewController: UIViewController, FoursquareClient {
    
    // MARK: Properties
    var interest: String?
    
    // MARK: Outlets
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("view loaded")
        getVenuesBySearch(using: "Culture", latitude: 40.7, longitude: -74) { ( success, response, error) in
            if success {
                print("It worked")
            } else {
                print("It failed")
            }
        
        
        }
    }
    
}
