//
//  VenueResponse.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/21/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

struct VenueResponse {
    
    // MARK: Properties
    var id: String?
    var name: String?
    var address: [String]?
    var latitude: Double?
    var longitude: Double?
    var checkinsCount: Double?
    
    // MARK: Initializers
    init(value: [String:AnyObject]) {
        
        self.id = value[FoursquareConstants.JSONResponseKeys.Id] as? String
        self.name = value[FoursquareConstants.JSONResponseKeys.Name] as? String
        self.address = value[FoursquareConstants.JSONResponseKeys.Address] as? [String]
        self.latitude = value[FoursquareConstants.JSONResponseKeys.Latitude] as? Double
        self.longitude = value[FoursquareConstants.JSONResponseKeys.Longitude] as? Double
        self.checkinsCount = value[FoursquareConstants.JSONResponseKeys.Checkins] as? Double ?? 0
    }
}
