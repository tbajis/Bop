//
//  Pin+CoreDataClass.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData
import MapKit

// MARK: - Pin: NSManagedObject, MKAnnotation

class Pin: NSManagedObject, MKAnnotation {

    // Allow Pin class to conform to MKAnnotation
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var title: String? {
        return name
    }
    var subtitle: String? {
        let count = Int(checkinsCount)
        return "Check In Count is: \(count)"
    }
    
    // MARK: Initializer
    
    convenience init(name: String?, id: String?, latitude: Double, longitude: Double, address: String?, checkinsCount: Double, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Pin", in: context) {
            self.init(entity: ent, insertInto: context)
            self.name = name
            self.id = id
            self.latitude = latitude
            self.longitude = longitude
            self.address = address
            self.checkinsCount = checkinsCount
        } else {
            fatalError("Unable to find Entity Pin")
        }
    }

}
