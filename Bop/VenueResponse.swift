//
//  VenueResponse.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/21/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

struct VenueResponse {
    
    // MARK: Properties
    var id: String?
    var name: String?
    var address: [String]?
    var latitude: Double?
    var longitude: Double?
    var checkinsCount: Int?
    
    // MARK: Initializers
    init(value: [String:AnyObject]) {
        
        self.id = value[FoursquareClient.JSONResponseKeys.Id] as? String
        self.name = value[FoursquareClient.JSONResponseKeys.Name] as? String
        self.address = value[FoursquareClient.JSONResponseKeys.Address] as? [String]
        self.latitude = value[FoursquareClient.JSONResponseKeys.Latitude] as? Double
        self.longitude = value[FoursquareClient.JSONResponseKeys.Longitude] as? Double
        self.checkinsCount = value[FoursquareClient.JSONResponseKeys.Checkins] as? Int
    }

    // Helpers
    static func venuesFromJSON(_ results: [[String:AnyObject]]) -> [VenueResponse] {
        
        var venues = [VenueResponse]()
        
        for (index, var result) in results.enumerated() {
            guard let _ = result[FoursquareClient.JSONResponseKeys.Id] as? String, let _ = result[FoursquareClient.JSONResponseKeys.Name] else {
                break
            }
            guard let locArray = result[FoursquareClient.JSONResponseKeys.Location] as? [String:AnyObject], let _ = locArray[FoursquareClient.JSONResponseKeys.Latitude] as? Double, let _ = locArray[FoursquareClient.JSONResponseKeys.Longitude] as? Double, let _ = locArray[FoursquareClient.JSONResponseKeys.Location] as? [String] else {
                break
            }
            guard let statsArray = result[FoursquareClient.JSONResponseKeys.Stats] as? [String:AnyObject], let _ = statsArray[FoursquareClient.JSONResponseKeys.Checkins] as? Int else {
                break
            }
            venues.append(VenueResponse(value: results[index]))
        }
        return venues
    }
}
