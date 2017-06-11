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
        
        let client = TWTRAPIClient()
        let interest = UserDefaults.standard.object(forKey: "Interest") as? String
        self.dataSource = TWTRSearchTimelineDataSource(searchQuery: interest!, apiClient: client)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Display a label on the background if there are no recent Tweets to display.
        let noTweetsLabel = UILabel()
        noTweetsLabel.text = "Sorry, there are no recent Tweets to display."
        noTweetsLabel.textAlignment = .center
        noTweetsLabel.textColor = UIColor.black
        noTweetsLabel.font = UIFont(name: "Avenir-Light", size: CGFloat(15))
        tableView.backgroundView = noTweetsLabel
        tableView.backgroundView?.isHidden = true
        tableView.backgroundView?.alpha = 0
        toggleNoTweetsLabel()
    }
    
    // MARK: Utilities
    
    fileprivate func toggleNoTweetsLabel() {
        if tableView.numberOfRows(inSection: 0) == 0 {
            UIView.animate(withDuration: 0.15, animations: {
                self.tableView.backgroundView!.isHidden = false
                self.tableView.backgroundView!.alpha = 1
            })
        } else {
            UIView.animate(withDuration: 0.15,
                           animations: {
                            self.tableView.backgroundView!.alpha = 0
            },
                           completion: { finished in
                            self.tableView.backgroundView!.isHidden = true
            }
            )
        }
    }
}
