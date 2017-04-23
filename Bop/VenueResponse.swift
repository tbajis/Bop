//
//  VenueResponse.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/21/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation


struct VenueResponse: FoursquareClient {
    
    // MARK: Properties
    var id: String?
    var name: String?
    var address: [String]?
    var latitude: Double?
    var longitude: Double?
    var checkinsCount: Int?
    
    // MARK: Initializers
    init(value: [String:AnyObject]) {
        
        self.id = value[FoursquareConstants.JSONResponseKeys.Id] as? String
        self.name = value[FoursquareConstants.JSONResponseKeys.Name] as? String
        self.address = value[FoursquareConstants.JSONResponseKeys.Address] as? [String]
        self.latitude = value[FoursquareConstants.JSONResponseKeys.Latitude] as? Double
        self.longitude = value[FoursquareConstants.JSONResponseKeys.Longitude] as? Double
        self.checkinsCount = value[FoursquareConstants.JSONResponseKeys.Checkins] as? Int
    }

// Helpers
    static func venuesFromJSON(_ results: [[String:AnyObject]]) -> [VenueResponse] {
        
        var venues = [VenueResponse]()
        
        for (index, var result) in results.enumerated() {
            guard let _ = result[FoursquareConstants.JSONResponseKeys.Id] as? String, let _ = result[FoursquareConstants.JSONResponseKeys.Name] else {
                break
            }
            guard let locArray = result[FoursquareConstants.JSONResponseKeys.Location] as? [String:AnyObject], let _ = locArray[FoursquareConstants.JSONResponseKeys.Latitude] as? Double, let _ = locArray[FoursquareConstants.JSONResponseKeys.Longitude] as? Double, let _ = locArray[FoursquareConstants.JSONResponseKeys.Location] as? [String] else {
                break
            }
            guard let statsArray = result[FoursquareConstants.JSONResponseKeys.Stats] as? [String:AnyObject], let _ = statsArray[FoursquareConstants.JSONResponseKeys.Checkins] as? Int else {
                break
            }
            venues.append(VenueResponse(value: results[index]))
        }
        return venues
    }
}
