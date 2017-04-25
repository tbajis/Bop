//
//  Pin+CoreDataClass.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData


class Pin: NSManagedObject {

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
