//
//  BopError.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/23/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - BopError (Convenient Resource)

struct BopError {
    
    // MARK: Map
    
    static var UserLocation = "An error occured trying to get user location"
    static var PinPlacement = "An error occured trying to place pins on the map"
    static var NoVenues = "No Venues were returned from search"
    
    // MARK: Detail View
    
    static var PhotosLoad = "An error occured trying to saved photos"
    static var DownloadPhotos = "No photos could be downloaded!"
}
