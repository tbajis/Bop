//
//  BopTwitterViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import TwitterKit

// MARK: BopTwitterViewController: TWTRTTimelineViewController
class BopTwitterViewController: TWTRTimelineViewController {
    
    // MARK: Properties
    var pin: Pin?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Updates for (CITY)"
        let client = TWTRAPIClient()
        let interest = UserDefaults.standard.object(forKey: "Interest") as? String
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: interest!, apiClient: client)
    }
}
