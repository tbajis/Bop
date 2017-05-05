//
//  FoursquareConvenience.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

// MARK: - FoursquareRequestType (Convenient Resource Method[s])


extension FoursquareRequestType {
    
    func getVenuesBySearch(using query: String, latitude: Double, longitude: Double, completionHandlerForSearchVenues: @escaping(_ success: Bool, _ venues: [VenueResponse]?, _ error: String?) -> Void) {
        
        // Create Parameters for request
        let parameters = [
            FoursquareConstants.JSONRequestKeys.ClientId: FoursquareConstants.ClientId,
            FoursquareConstants.JSONRequestKeys.ClientSecret: FoursquareConstants.ClientSecret,
            FoursquareConstants.JSONRequestKeys.Location: generateLocation(latitude, longitude),
            FoursquareConstants.JSONRequestKeys.Query: query,
            FoursquareConstants.JSONRequestKeys.Limit: "10",
            FoursquareConstants.JSONRequestKeys.Date: generateDate(),
            FoursquareConstants.JSONRequestKeys.ResponseType: "foursquare"
//            FoursquareConstants.JSONRequestKeys.Radius: "10"
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
            let venues = self.venuesFromJSON(venuesArray)
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

    // Create VenueResponse objects from JSON
    func venuesFromJSON(_ results: [[String:AnyObject]]) -> [VenueResponse] {
        
        var venues = [VenueResponse]()
        
        for (_, var result) in results.enumerated() {

                guard let id = result[FoursquareConstants.JSONResponseKeys.Id] as? String, let name = result[FoursquareConstants.JSONResponseKeys.Name] else {
                    print("Failed to parse id")
                    continue
                }
                guard let locArray = result[FoursquareConstants.JSONResponseKeys.Location] as? [String:AnyObject], let lat = locArray[FoursquareConstants.JSONResponseKeys.Latitude] as? Double, let lon = locArray[FoursquareConstants.JSONResponseKeys.Longitude] as? Double, let address = locArray[FoursquareConstants.JSONResponseKeys.Address] as? [String] else {
                    print("Failed to parse address")
                    continue
                }
                guard let statsArray = result[FoursquareConstants.JSONResponseKeys.Stats] as? [String:AnyObject], let checkinsCount = statsArray[FoursquareConstants.JSONResponseKeys.Checkins] as? Int else {
                    print("Failed to parse stats")
                    continue
                }
                let filteredVenue: [String:AnyObject] = [
                    FoursquareConstants.JSONResponseKeys.Id: id as AnyObject,
                    FoursquareConstants.JSONResponseKeys.Name: name as AnyObject,
                    FoursquareConstants.JSONResponseKeys.Address: address as AnyObject,
                    FoursquareConstants.JSONResponseKeys.Latitude: lat as AnyObject,
                    FoursquareConstants.JSONResponseKeys.Longitude: lon as AnyObject,
                    FoursquareConstants.JSONResponseKeys.Checkins: checkinsCount as AnyObject
                ]
                let venue = VenueResponse(value: filteredVenue)
                venues.append(venue)
        }
        return venues
    }
    
    // Create PhotoResponse objects from JSON
    func photosFromJSON(_ results: [[String:AnyObject]]) -> [PhotoResponse] {
        
        var photos = [PhotoResponse]()
        
        for (_, var result) in results.enumerated() {
            guard let prefix = result[FoursquareConstants.JSONResponseKeys.Prefix] as? String, let suffix = result[FoursquareConstants.JSONResponseKeys.Suffix] as? String, let width = result[FoursquareConstants.JSONResponseKeys.Width] as? Int, let height = result[FoursquareConstants.JSONResponseKeys.Height] as? Int else {
                break
            }
            let photoURL = prefix + "\(width)x\(height)" + suffix
            if let url = URL(string: photoURL) {
                if UIApplication.shared.canOpenURL(url) {
                    let filteredPhoto: [String:AnyObject] = [
                        "mediaURL": url as AnyObject,
                        FoursquareConstants.JSONResponseKeys.Height: height as AnyObject,
                        FoursquareConstants.JSONResponseKeys.Width: width as AnyObject
                    ]
                    photos.append(PhotoResponse(value: filteredPhoto))
                }
            }
        }
        return photos
    }
}
