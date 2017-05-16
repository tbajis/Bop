//
//  BopPageViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/11/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

class BopPageViewController: UIPageViewController, UIPageViewControllerDataSource, FoursquareRequestType {

    // MARK: Properties
    var contentImages: [UIImage] = [UIImage(named: "placeholder")!]
    var pin: Pin?
    
    // MARK: Outlets
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        if pin != nil {
            print("This worked!")
        }
        
        setVenueImages() { (success) in
            performUIUpdatesOnMain {
                guard success == true else {
                    print("THIS DIDN'T WORK")
                    if self.contentImages.count > 0 {
                        let firstController = self.getItemController(0)!
                        let startingViewControllers = [firstController]
                        self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                    }
                    return
                }
                if self.contentImages.count > 0 {
                    let firstController = self.getItemController(0)!
                    let startingViewControllers = [firstController]
                    
                    self.setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
                }
            }
        }
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }

    // MARK: Helpers
    func setVenueImages(completion: @escaping (_ success: Bool) -> Void) {
        
        getImageInfo() { (success, photos) in
            guard success else {
                completion(false)
                return
            }
            self.getVenueImages(success, photos) { (success) in
                print("THIS SHOULD HAVE WORKED")
                completion(success)
            }
        }
    }
    
    func getImageInfo(completion: @escaping (_ success: Bool, _ photos: [Photo]?) -> Void) {
        
        self.getPhotosForVenue(using: pin?.id) { (success, photoResponses, error) in
            performUIUpdatesOnMain {
                var photos = [Photo]()
                guard error == nil else {
                    self.displayError(error)
                    completion(false, nil)
                    return
                }
                guard let responses = photoResponses, responses.count > 0 else {
                    self.displayError("Photo responses were not downloaded")
                    completion(false, nil)
                    return
                }
                for response in responses {
                    let urlString = response.mediaURL?.absoluteString
                    print(urlString)
                    let photo = Photo(id: response.id, height: Double(response.height!), width: Double(response.width!), mediaURL: urlString!, context: AppDelegate.stack.context)
                    photo.pin = self.pin
                    photos.append(photo)
                    AppDelegate.stack.save()
                }
                completion(success, photos)
            }
        }
    }
    
    func getVenueImages(_ success: Bool, _ photos: [Photo]?, _ completion: @escaping (_ success: Bool) -> Void) {
        
        guard success else {
            print("Venue image data could not be acquired")
            completion(false)
            return
        }
        guard let photos = photos else {
            print("No photos were found!")
            completion(false)
            return
        }
        for photo in photos {
            self.getFoursquareImages(photo) { (success, error, imageData) in
                performUIUpdatesOnMain {
                    guard error == nil else {
                        self.displayError(error)
                        return
                    }
                    guard success else {
                        self.displayError("Venue image data acquire was not successful")
                        return
                    }
                    guard let data = imageData else {
                        return
                    }
                    guard let venueImage = UIImage(data: data) else {
                        return
                    }
                    self.contentImages.append(venueImage)
                    if self.contentImages.count == photos.count {
                        completion(true)
                    }
                }
            }
        }
    }
    
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentControllerIndex()
        if let controller = pageItemController as? BopVenueImageViewController {
            return controller.itemIndex
        }
        return -1
    }
    
    func getItemController(_ itemIndex: Int) -> BopVenueImageViewController? {
        
        if itemIndex < (contentImages.count) {
            let pageItemController = self.storyboard?.instantiateViewController(withIdentifier: "BopVenueImageViewController") as! BopVenueImageViewController
            pageItemController.itemIndex = itemIndex
            pageItemController.imageName = (contentImages[itemIndex])
            return pageItemController
        }
        return nil
    }
    
    // MARK: Utilities
    func displayError(_ error: String?) {
        print(error)
    }
    
    // MARK: Page ViewController Data Source
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! BopVenueImageViewController
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! BopVenueImageViewController
        if itemController.itemIndex + 1 < (contentImages.count) {
            return getItemController(itemController.itemIndex + 1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        if let count = contentImages.count as? Int {
            return count
        } else {
            return 1
        }
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
}
