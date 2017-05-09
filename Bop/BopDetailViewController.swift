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
    var imageIndex = 0
    var venueImages = [UIImage]()
    var maxImages = 2
    
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
                        performUIUpdatesOnMain {
                            if success && error == nil {
                                let venueImage = UIImage(data: imageData!)
                                self.venueImages.append(venueImage!)
                            } else {
                                print("Image could not be downloaded")
                            }
                        self.venueImageView.image = self.venueImages[self.imageIndex]
                        print("There are \(self.venueImages.count) images")
                        }
                    
                    }
                }
            } else {
                self.displayError("Image could not be downloaded and displayed")
            }
        }
    }
    
    // MARK: Actions
    
    @IBAction func swipedRight(_ sender: Any) {
    
        print("User swiped right")
        imageIndex -= 1
        if imageIndex < 0 {
            imageIndex = maxImages
        }
        venueImageView.image = venueImages[imageIndex]
    }
    
    @IBAction func swipedLeft(_ sender: Any) {
    
        print("User swiped left")
        imageIndex += 1
        if imageIndex > maxImages {
            imageIndex = 0
        }
        venueImageView.image = venueImages[imageIndex]
    }
    
    
    
    @IBAction func userDidSwipe(_ sender: Any) {
        
        if let gesture = sender as? UISwipeGestureRecognizer {
            
            switch gesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("User swiped right")
                imageIndex -= 1
                if imageIndex < 0 {
                    imageIndex = maxImages
                }
                venueImageView.image = venueImages[imageIndex]
            case UISwipeGestureRecognizerDirection.left:
                print("User swiped left")
                imageIndex += 1
                if imageIndex > maxImages {
                    imageIndex = 0
                }
                venueImageView.image = venueImages[imageIndex]
            default:
                break
            }

        }
        
    }
    
    @IBAction func imageSwiped(_ sender: Any) {
        
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
