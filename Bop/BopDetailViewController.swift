//
//  BopDetailViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import TwitterKit

// MARK: BopDetailViewController: TWTRTTimelineViewController
class BopDetailViewController: TWTRTimelineViewController {
    
    // MARK: Properties
    var pin: Pin?
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let client = TWTRAPIClient()
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: "#Trump", apiClient: client)
    }
}
