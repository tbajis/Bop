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
    var scrollViewImages = [UIImage]()

    // MARK: Outlets
    @IBOutlet weak var twitterView: UIView!
    @IBOutlet weak var venueScrollView: UIScrollView!
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    
        /* TODO: Configure the UI */
        configureSetUp() { (success) in
            print("SUCCESS")
        }
        
    }
    
    // MARK: Actions
    
    // MARK: Helpers
    func configureSetUp(completion: @escaping (_ success: Bool) -> Void) {
        configureUI() { (success, photos) in
            self.configureImages(success, photos) { (success) in
                self.configureScrollView()
            }
        
        }
    }
    
    func configureImages(_ success: Bool, _ photos: [Photo]?, _ completion: @escaping (_ success: Bool) -> Void) {
        guard success else {
            print("Venue Image data could not be acquired")
            return
        }
        guard let photos = photos else {
            print("No photos were found!")
            return
        }
        for photo in photos {
            self.getFoursquareImages(photo) { (success, error, imageData) in
                performUIUpdatesOnMain {
                    guard success == true, error == nil else {
                        print("An error occured trying to use Image Data")
                        return
                    }
                    guard let data = imageData else {
                        print("No image data was provided")
                        return
                    }
                    let venueImage = UIImage(data: data)
                    self.venueImages.append(venueImage!)
                    
                    if self.venueImages.count == photos.count {
                        print(self.venueImages.count)
                        self.scrollViewImages = self.venueImages
                        completion(true)
                    }
                }
            }
        }
    }
    
    func configureUI(completion: @escaping (_ success: Bool, _ photos: [Photo]?) -> Void) {
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
    
    func configureScrollView() {
        for i in 0..<scrollViewImages.count {
            let imageView = UIImageView()
            imageView.image = scrollViewImages[i]
            imageView.contentMode = .scaleAspectFit
            let x = self.view.frame.width * CGFloat(i)
            imageView.frame = CGRect(x: x, y: self.venueScrollView.frame.origin.y, width: self.venueScrollView.frame.width, height: self.venueScrollView.frame.height)
            
            venueScrollView.contentSize.width = venueScrollView.frame.width * CGFloat(i + 1)
            venueScrollView.addSubview(imageView)
        }
    }
    
}
