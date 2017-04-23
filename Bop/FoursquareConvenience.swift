//
//  FoursquareConvenience.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - FoursquareClient (Convenient Resource Method[s])

extension FoursquareClient {
    
    func getVenuesBySearch(using query: String, latitude: Double, longitude: Double, completionHandlerForSearchVenues: @escaping(_ success: Bool, _ venues: [VenueResponse]?, _ error: String?) -> Void) {
        
        // Create Parameters for request
        let parameters = [
            FoursquareConstants.JSONRequestKeys.ClientId: FoursquareConstants.ClientId,
            FoursquareConstants.JSONRequestKeys.ClientSecret: FoursquareConstants.ClientSecret,
            FoursquareConstants.JSONRequestKeys.Location: generateLocation(latitude, longitude),
            FoursquareConstants.JSONRequestKeys.Query: query,
            FoursquareConstants.JSONRequestKeys.Limit: "1",
            FoursquareConstants.JSONRequestKeys.Date: generateDate(),
            FoursquareConstants.JSONRequestKeys.ResponseType: "foursquare"
        ] as [String:AnyObject]
        
        let _ = taskForGETMethod(FoursquareConstants.Methods.GETSearchVenues, parameters: parameters) { (result, error) in
        
            guard error == nil else {
                print("There was an error in getVenuesBySearch()")
                completionHandlerForSearchVenues(false, nil, error)
                return
            }
            guard let responseDict = result?["response"] as? [String:AnyObject], let venuesArray = responseDict["venues"] as? [[String:AnyObject]] else {
                print("There was an error parsing in getVenuesBySearch")
                completionHandlerForSearchVenues(false, nil, "An error occured!")
                return
            }
            let venues = VenueResponse.venuesFromJSON(venuesArray)
            completionHandlerForSearchVenues(true, venues, nil)
        }
    }
    
    
    // Generate the date in specified format "YYYMMDD"
    func generateDate() -> String {
        
        let dateFormatter = DateFormatter()
        let date = Date()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
    
    // Generate location string
    func generateLocation(_ latitude: Double, _ longitude: Double) -> String {
        return "\(latitude),\(longitude)"
    }
}
