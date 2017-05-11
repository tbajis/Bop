//
//  BopPageViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/11/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit

class BopPageViewController: UIPageViewController, UIPageViewControllerDataSource {

    // MARK: Properties
    let contentImages = ["placeholder", "placeholder2", "placeholder3"]
    
    // MARK: Outlets
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dataSource = self
        
        
        if contentImages.count > 0 {
            let firstController = getItemController(0)!
            let startingViewControllers = [firstController]
            
            setViewControllers(startingViewControllers, direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }
        
        /* TODO: SET UP PAGE CONTROL */
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.gray
        appearance.currentPageIndicatorTintColor = UIColor.white
        appearance.backgroundColor = UIColor.darkGray
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! BopVenueImageViewController
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex - 1)
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! BopVenueImageViewController
        if itemController.itemIndex + 1 < contentImages.count {
            return getItemController(itemController.itemIndex + 1)
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return contentImages.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func currentControllerIndex() -> Int {
        
        let pageItemController = self.currentControllerIndex()
        if let controller = pageItemController as? BopVenueImageViewController {
            return controller.itemIndex
        }
        return -1
    }
    
    func getItemController(_ itemIndex: Int) -> BopVenueImageViewController? {
        
        if itemIndex < contentImages.count {
            let pageItemConroller = self.storyboard?.instantiateViewController(withIdentifier: "BopVenueImageViewController") as! BopVenueImageViewController
            pageItemConroller.itemIndex = itemIndex
            pageItemConroller.imageName = contentImages[itemIndex]
            return pageItemConroller
        }
        return nil
    }
}
