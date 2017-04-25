//
//  Interest+CoreDataProperties.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData


extension Interest {

    // MARK: Properties
    @NSManaged var category: String?
    @NSManaged var query: String?
    @NSManaged var pins: NSSet?

}

