//
//  Photo+CoreDataClass.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//
import Foundation
import CoreData

// MARK: - Photo: NSManagedObject

class Photo: NSManagedObject {
    
    // MARK: Initializer
    
    convenience init(id: String?, height: Double, width: Double, mediaURL: String, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Photo", in: context) {
            self.init(entity: ent, insertInto: context)
            self.id = id
            self.mediaURL = mediaURL
            self.width = width
            self.height = height
        } else {
            fatalError("Unable to find Entity Photo")
        }
    }
}
