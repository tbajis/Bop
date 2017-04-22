//
//  PhotoResponse.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/22/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit

struct PhotoResponse {
    
    // MARK: Properties
    var mediaURL: URL?
    var height: Int?
    var width: Int?
    
    // MARK: Initializers
    init(value: [String:AnyObject]) {
        self.mediaURL = value["mediaURL"] as? URL
        self.height = value[FoursquareClient.JSONResponseKeys.Height] as? Int
        self.width = value[FoursquareClient.JSONResponseKeys.Width] as? Int
    }
    
    // Helpers
    static func photosFromJSON(_ results: [[String:AnyObject]]) -> [PhotoResponse] {
        
        var photos = [PhotoResponse]()
        
        for (_, var result) in results.enumerated() {
            guard let prefix = result[FoursquareClient.JSONResponseKeys.Prefix] as? String, let suffix = result[FoursquareClient.JSONResponseKeys.Suffix] as? String, let width = result[FoursquareClient.JSONResponseKeys.Width] as? Int, let height = result[FoursquareClient.JSONResponseKeys.Height] as? Int else {
                break
            }
            let photoURL = prefix + "\(width)x\(height)" + suffix
            if let url = URL(string: photoURL) {
                if UIApplication.shared.canOpenURL(url) {
                    let filteredPhoto: [String:AnyObject] = [
                        "mediaURL": url as AnyObject,
                        FoursquareClient.JSONResponseKeys.Height: height as AnyObject,
                        FoursquareClient.JSONResponseKeys.Width: width as AnyObject
                    ]
                    photos.append(PhotoResponse(value: filteredPhoto))
                }
            }
        }
        return photos
    }
}
