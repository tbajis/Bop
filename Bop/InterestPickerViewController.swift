//
//  InterestPickerViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class InterestPickerViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    // MARK: Outlets
    @IBOutlet var interestButtons: [InterestButton]!
    @IBOutlet weak var continueButton: UIButton!
    
    // MARK: Properties
    var interest: Interest?
    
    // Create a fetchedResultsController to retrieve and monitor changes in CoreDataModel
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Interest")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        /* TODO: set up a fetched results request for Interest entity
         if there is a result, check for which interest corresponding button, set it to be highlighted
         set all other buttons not highlighted
         */
        fetchedResultsController?.delegate = self
        continueButton.isEnabled = false
        // Set buttons to red background color
        for button in interestButtons {
            button.backgroundColor = UIColor.red
        }
        // Set background color of persisted interest
        configureInterest()
    }
    // MARK: Actions
    @IBAction func interestButtonPressed(_ sender: InterestButton) {
        
        toggleButton(sender, {
            self.updateContinueButton()
        })
        
        /*for button in interestButtons {
            button.backgroundColor = UIColor.red
            sender.backgroundColor = UIColor.gray
            continueButton.isEnabled = true
        }
        if sender.backgroundColor == UIColor.gray {
            let persistedCategory = String(sender.tag)
            let persistedQuery = sender.queryString(for: InterestButton.Category(rawValue: sender.tag)!)
            self.interest = Interest(category: persistedCategory, query: persistedQuery, context: AppDelegate.stack.context)
        }*/
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        for button in interestButtons {
            if button.isToggle {
                let category = String(button.tag)
                let query = button.queryString(for: InterestButton.Category(rawValue: sender.tag)!)
                self.interest = Interest(category: category, query: query, context: AppDelegate.stack.context)
                print(interest?.category)
                AppDelegate.stack.save()
                navigateToTabViewController()
            }
        }
        
        
        /*for button in interestButtons {
            if button.backgroundColor == UIColor.gray {
                let category = button.queryString(for: InterestButton.Category(rawValue: button.tag)!)
                /* TODO: Initialize an instance of managed object Interest  by starting network request */
                /* TODO: PerformSegue */
                print("query: \(category)")
                performSegue(withIdentifier: "ShowMapAndTable", sender: self)
            }
        }*/
    }
    
    // Utilities
    func configureInterest() {
        
        executeSearch()
        if let interests = fetchedResultsController?.fetchedObjects as? [Interest] {
            for interest in interests {
                AppDelegate.stack.context.delete(interest)
                AppDelegate.stack.save()
            }
        }
    }
    
    func executeSearch() {
        
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
            }
        }
    }
    
    func setButton(with tag: Int) {
        
        for button in interestButtons {
            if button.tag == tag {
                button.backgroundColor = UIColor.gray
            }
        }
    }
    
    func toggleButton(_ sender: InterestButton, _ handler: @escaping () -> Void) {
        
        for button in interestButtons {
            if button == sender {
                button.isToggle = true
            } else {
                button.isToggle = false
            }
        }
        handler()
    }
    
    func updateContinueButton() {
        
        for button in interestButtons {
            if button.isToggle == true {
                self.continueButton.isEnabled = true
            }
        }
    }
    
    // Helpers
    func navigateToTabViewController() {
        performSegue(withIdentifier: "ShowMapAndTable", sender: self)
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
}
