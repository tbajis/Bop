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

        fetchedResultsController?.delegate = self
        executeSearch()
        continueButton.isEnabled = false
        
        // Set buttons to red background color
        for button in interestButtons {
            button.backgroundColor = UIColor.red
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        if interestSaved() {
            deleteInterest()
        }
    }
    
    // MARK: Actions
    @IBAction func interestButtonPressed(_ sender: InterestButton) {
        
        toggleButton(sender, {
            self.updateContinueButton()
        })
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
    }
    
    // Utilities
    func executeSearch() {
        
        if let fc = fetchedResultsController {
            do {
                try fc.performFetch()
            } catch let e as NSError {
                print("Error while trying to perform a search: \n\(e)\n\(fetchedResultsController)")
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
    
    func interestSaved() -> Bool {
        if let interests = fetchedResultsController?.fetchedObjects as? [Interest], interests.count > 0 {
           return true
        } else {
            return false
        }
    }
    
    func deleteInterest() {
        if let interests = fetchedResultsController?.fetchedObjects as? [Interest] {
            for interest in interests {
                AppDelegate.stack.context.delete(interest)
            }
        }
    }
    
    // Helpers
    func navigateToTabViewController() {
        let nextController = storyboard?.instantiateViewController(withIdentifier: "MapAndTableTabBarController") as! UITabBarController
        present(nextController, animated: true, completion: nil)
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
