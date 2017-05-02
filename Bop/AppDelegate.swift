//
//  AppDelegate.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import CoreData
import Fabric
import Crashlytics
import TwitterKit
import DigitsKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, NSFetchedResultsControllerDelegate {
    
    var window: UIWindow?
    
    // Create a fetchedResultsController to retrieve and monitor changes in CoreDataModel
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Interest")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // Create a shared stack for managing the main context
    static let stack = CoreDataStack(modelName: "Bop")!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        // Register for Twitter with Fabric.app.
        Fabric.with([Twitter.self, Digits.self, Crashlytics.self])
        
        // Check for an existing Twitter session before presenting the login screen.
        if Twitter.sharedInstance().sessionStore.session() == nil && Digits.sharedInstance().session() == nil {
            
            if interestSaved() {
                navigateToTabViewController()
            } else {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                self.window?.makeKeyAndVisible()
                self.window?.rootViewController = loginViewController
            }
        }
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    
    func interestSaved() -> Bool {
        
        if let interests = fetchedResultsController?.fetchedObjects as? [Interest], interests.count > 0 {
            return true
        } else {
            return false
        }
    }
    
    func navigateToTabViewController() {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewController(withIdentifier: "MapAndTableTabBarController") as? UITabBarController
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = tabBarController
    }
}
