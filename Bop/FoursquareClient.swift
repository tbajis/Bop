//
//  FoursquareClient.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/19/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation

// MARK: - FoursquareClient: NSObject

class FoursquareClient: NSObject {
    
    // Shared session
    var session = URLSession.shared
    
    // MARK: Initializers
    override init() {
        super.init()
    }
    
    // MARK: GET
    func taskForGETMethod(_ method: String, parameters: [String:AnyObject], completionHandlerForGET: @escaping (_ result: [String:AnyObject]?, _ error: String?) -> Void) -> URLSessionDataTask {
        
        // Set any method parameters
        let parameters = parameters
        
        // Build the URL and configure the request
        let request = NSMutableURLRequest(url: foursquareURLBuilder(parameters: parameters, withPathExtension: method))
        print(request.url!)
        
        // Make the request
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            func sendError(_ error: String) {
                print(error)
                completionHandlerForGET(nil, error)
            }
            // GUARD against an error
            guard error == nil else {
                sendError(FoursquareClient.Error.Request + "\(error!.localizedDescription)")
                return
            }
            // GUARD against an unsuccessful response
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                sendError(FoursquareClient.Error.StatusCode)
                return
            }
            // GUARD against no data being returned
            guard let data = data else {
                sendError(FoursquareClient.Error.Data)
                return
            }
            // Parse and use the data (happens in completion handler)
            self.convertDataWithCompletionHandler(data, completionHandlerForConvertedData: completionHandlerForGET)
        }
        task.resume()
        return task
    }
    // MARK: Helpers
    // Create a url from parameters
    private func foursquareURLBuilder(parameters: [String:AnyObject], withPathExtension: String?) -> URL {
        
        var components = URLComponents()
        components.scheme = FoursquareClient.Constants.ApiScheme
        components.host = FoursquareClient.Constants.ApiHost
        components.path = FoursquareClient.Constants.ApiPath + (withPathExtension ?? "")
        components.queryItems = [URLQueryItem]()
        
        for (key, value) in parameters {
            let queryItem = URLQueryItem(name: key, value: "\(value)")
            components.queryItems?.append(queryItem)
        }
        return components.url!
    }
    
    // Given raw JSON, return a usable object
    private func convertDataWithCompletionHandler(_ data: Data, completionHandlerForConvertedData: (_ result: [String:AnyObject]?, _ error: String?) -> Void) {
        
        print(NSString(data: data, encoding: String.Encoding.utf8.rawValue))
        var parsedResult: [String:AnyObject]?
        do {
            parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:AnyObject]
        } catch {
            completionHandlerForConvertedData(nil, FoursquareClient.Error.Serialization)
        }
        completionHandlerForConvertedData(parsedResult, nil)
    }
    
    
    // Substitude the key for the value contained within the method name
    func substituteKeyInMethod( _ method: String, key: String, value: String) -> String {
        
        if method.range(of: "\(key)") != nil {
            return method.replacingOccurrences(of: "\(key)", with: value)
        } else {
            return method
        }
    }
    
    // Generate the date in specified format "YYYMMDD"
    func generateDate() -> String {
        
        let dateFormatter = DateFormatter()
        let date = Date()
        
        dateFormatter.dateFormat = "yyyyMMdd"
        let convertedDate = dateFormatter.string(from: date)
        return convertedDate
    }
}
