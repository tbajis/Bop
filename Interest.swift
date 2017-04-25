//
//  Interest+CoreDataClass.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData


class Interest: NSManagedObject {

    // MARK: Initializer
    convenience init(category: String?, query: String?, context: NSManagedObjectContext) {
        if let ent = NSEntityDescription.entity(forEntityName: "Interest", in: context) {
            self.init(entity: ent, insertInto: context)
            self.category = category
            self.query = query
        } else {
            fatalError("Unable to find Entity name!")
        }
    }
}
