//
//  FoursquareConstants.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - FoursquareClient (Constants)

extension FoursquareClient {

    // MARK: Constants
    struct Constants {
        
        // MARK: URLs
        static let ApiScheme = "https"
        static let ApiHost = "api.foursquare.com"
        static let ApiPath = "/v2"
    }
    
    // MARK: Credentials
    static let ClientId = "YOUR CLIENT ID HERE"
    static let ClientSecret = "YOUR CLIENT SECRET HERE"
    
    // MARK: Methods
    struct Methods {
        
        // MARK: Search venues
        static let GETSearchVenues = "/venues/search"
    }
    
    // MARK: JSON Response Keys
    struct JSONResponseKeys {
        
        static let Response = "response"
        static let Venues = "venues"
        static let Id = "id"
        static let Photos = "photos"
        static let Items = "items"
        static let Prefix = "prefix"
        static let Suffix = "suffix"
        static let Width = "width"
        static let height = "height"
    }
    
    // MARK: Errors
    struct Error {
        
        // MARK: Network Requests
        static let Request = "There was an error with your request"
        static let StatusCode = "Your request returned an unsuccessful status code"
        static let Data = "No data was returned by the request"
        
        // MARK: Parsing data
        static let Serialization = "Could not serialize the data into JSON"
    }
}
