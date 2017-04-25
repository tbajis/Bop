//
//  Pin+CoreDataProperties.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData


extension Pin {

    // MARK: Properties
    @NSManaged var address: String?
    @NSManaged var checkinsCount: Double
    @NSManaged var id: String?
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var name: String?
    @NSManaged var interest: Interest?
    @NSManaged var photos: NSSet?

}

