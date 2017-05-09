//
//  Photo+CoreDataClass.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/24/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    // MARK: Initializer
    convenience init(id: String?, prefix: String?, suffix: String?, height: Double, width: Double, mediaURL: String, context: NSManagedObjectContext) {
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
    
    // MARK: Helpers
    private func formatMediaURL(prefix: String?, suffix: String?, height: Double?, width: Double?) -> String? {
        
        guard let prefix = prefix, let suffix = suffix, let height = height, let width = width else {
            return "placeholder"
        }
        let urlString: String? = prefix + "\(height)x\(width)" + suffix
        return urlString
    }
}
