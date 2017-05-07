//
//  BopTableViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import CoreData

// MARK: - BopTableViewController: CoreDataTableViewController

class BopTableViewController: CoreDataTableViewController {
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = "Venes"
        
        // Create a fetchedResultsController
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    // MARK: TableView Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let venue = fetchedResultsController?.object(at: indexPath) as! Pin
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinTableCell", for: indexPath)
        
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = "Checkin count is \(venue.checkinsCount)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let pin = fetchedResultsController?.object(at: indexPath) as! Pin
        performSegue(withIdentifier: "showDetailFromTable", sender: pin)
    }
    // MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailFromTable" {
            let detailController = segue.destination as! BopDetailViewController
            let venue = sender as? Pin
            detailController.pin = venue
        }
    }
}
