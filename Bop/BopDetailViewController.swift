//
//  BopDetailViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/6/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import CoreData

// MARK: BopDetailViewController: UIViewController

class BopDetailViewController: UIViewController, FoursquareRequestType {
    
    // MARK: Properties
    var pin: Pin?
    
    // MARK: Outlets
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var venueImageView: UIImageView!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        /* TODO: Configure the UI */
        configureUI() { (success, photos) in
            if success {
                for photo in photos! {
                    self.getFoursquareImages(photo) { (success, error, imageData) in
                        if success {
                            self.venueImageView.image = UIImage(data: imageData!)
                        } else {
                            print("Image could not be downloaded")
                        }
                    
                    }
                }
            } else {
                self.displayError("Image could not be downloaded and displayed")
            }
        }
        
        
    }
    
    // MARK: Helpers
    func configureUI(completion: @escaping (_ success: Bool, [Photo]?) -> Void) {
        self.getPhotosForVenue(using: pin?.id) { (success, photoResponses, error) in
            performUIUpdatesOnMain {
                var photos = [Photo]()
                guard error == nil else {
                    self.displayError("An error occured")
                    completion(false, nil)
                    return
                }
                for photoResponse in photoResponses! {
                    let urlString = photoResponse.mediaURL?.absoluteString
                    print(urlString)
                    let photo = Photo(id: photoResponse.id, prefix: nil, suffix: nil, height: Double(photoResponse.height!), width: Double(photoResponse.width!), mediaURL: urlString!, context: AppDelegate.stack.context)
                    photo.pin = self.pin
                    photos.append(photo)
                    AppDelegate.stack.save()
                }
                completion(success, photos)
            }
        }
    }

    // MARK: Utilities
    func displayError(_ error: String?) {
        print(error)
    }
    
}
