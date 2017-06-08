//
//  FoursquareConstants.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - FoursquareConstants

class FoursquareConstants {

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
        
        // MARK: Venue Photos
        
        static let GETVenuePhotos = "/venues/<VenueID>/photos"
    }
    
    // MARK: JSON Request Keys
    
    struct JSONRequestKeys {
        
        static let ClientId = "client_id"
        static let ClientSecret = "client_secret"
        static let Location = "ll"
        static let Query = "query"
        static let Limit = "limit"
        static let Date = "v"
        static let ResponseType = "m"
        static let Radius = "radius"
        static let VenueID = "<VenueID>"
    }
    
    // MARK: JSON Response Keys
    
    struct JSONResponseKeys {
        
        static let Response = "response"
        static let Venues = "venues"
        static let Id = "id"
        static let Name = "name"
        static let Location = "location"
        static let Latitude = "lat"
        static let Longitude = "lng"
        static let Address = "formattedAddress"
        static let Stats = "stats"
        static let Checkins = "checkinsCount"
        static let Photos = "photos"
        static let Items = "items"
        static let Prefix = "prefix"
        static let Suffix = "suffix"
        static let Width = "width"
        static let Height = "height"
    }
    
    // MARK: Errors
    
    struct Error {
        
        // MARK: Network Requests
        
        static let Request = "There was an error with your request"
        static let StatusCode = "Your request returned an unsuccessful status code"
        static let Data = "No data was returned by the request"
        
        // MARK: Parsing data
        
        static let Serialization = "Could not serialize the data into JSON"
        
        // MARK: Map
        
        static var UserLocation = "An error occured trying to get user location"
        static var PinPlacement = "An error occured trying to place pins on the map"
        static var NoVenues = "No Venues were returned from search"
        
        // MARK: Detail View
        
        static var PhotosLoad = "An error occured trying to saved photos"
        static var DownloadPhotos = "No photos could be downloaded!"
    }
}
