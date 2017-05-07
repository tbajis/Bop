//
//  CoreDataObject.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 5/3/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import CoreData

// MARK: - CoreDataObject: NSObject
class CoreDataObject: NSObject {
    
    // MARK: Properties
    var interest: Interest?
    var pin: Pin?
    var photo: Photo?
    
    // MARK: FetchedResultsControllers
    lazy var fetchedInterestResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Interest")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()

    
    lazy var fetchedPinResultsController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
//        fetchRequest.predicate = NSPredicate(format: "interest == %@", self.interest!)
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: Methods
    func executeInterestSearch() {
        
        do {
            try fetchedInterestResultsController.performFetch()
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)\n\(fetchedPinResultsController)")
        }
    }
    
    func executePinSearch() {
        
        do {
            try fetchedPinResultsController.performFetch()
        } catch let e as NSError {
            print("Error while trying to perform a search: \n\(e)\n\(fetchedPinResultsController)")
        }
    }
    
    // MARK: Shared Instance
    class func sharedInstance() -> CoreDataObject {
        struct Singleton {
            static var sharedInstance = CoreDataObject()
        }
        return Singleton.sharedInstance
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension CoreDataObject: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}

