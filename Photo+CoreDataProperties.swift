
//
//  Photo+CoreDataProperties.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//
import Foundation
import CoreData


extension Photo {
    
    // MARK: Properties
    @NSManaged var height: Double
    @NSManaged var id: String?
    @NSManaged var mediaURL: String
    @NSManaged var width: Double
    @NSManaged var pin: Pin?

}
