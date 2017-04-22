//
//  FoursquareConvenience.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - FoursquareClient (Convenient Resource Method[s])

extension FoursquareClient {
    
    
    
    
    // Generate the date in specified format "YYYMMDD"
    func generateDate() -> String {
        
        let dateFormatter = DateFormatter()
        let date = Date()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
}
