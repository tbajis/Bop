//
//  PhotoResponse.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/22/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

// MARK: - PhotoResponse

struct PhotoResponse {
    
    // MARK: Properties
    
    var id: String?
    var mediaURL: URL?
    var height: Int?
    var width: Int?
    
    // MARK: Initializers
    
    init(value: [String:AnyObject]) {
        self.id = value[FoursquareConstants.JSONResponseKeys.Id] as? String
        self.mediaURL = value["mediaURL"] as? URL
        self.height = value[FoursquareConstants.JSONResponseKeys.Height] as? Int
        self.width = value[FoursquareConstants.JSONResponseKeys.Width] as? Int
    }
}
