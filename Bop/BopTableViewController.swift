//
//  BopTableViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import UIKit
import CoreData
import Crashlytics
import TwitterKit
import DigitsKit

// MARK: - BopTableViewController: CoreDataTableViewController

class BopTableViewController: CoreDataTableViewController {
    
    // MARK: Properties
    var interest = UserDefaults.standard.object(forKey: "Interest") as? String
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set title
        title = "Venues"
        
        self.navigationItem.leftBarButtonItem?.setTitleTextAttributes([NSForegroundColorAttributeName:UIColor.white, NSFontAttributeName:UIFont(name: "Avenir-Light", size: 15)!], for: .normal)
        if let interest = interest {
            self.navigationItem.title = "Venues for \(interest)"
        }
        
        // Create a fetchedResultsController
        let fr = NSFetchRequest<NSFetchRequestResult>(entityName: "Pin")
        fr.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fr, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
        // Set Navigation Bar to backgroundGradient
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "bgGradient"), for: UIBarMetrics(rawValue: 0)!)
    }
    
    // MARK: Actions
    @IBAction func logout(_ sender: Any) {
        deletePinInfo() { (success) in
            if success {
                // Remove any Twitter or Digits local session for this app.
                let sessionStore = Twitter.sharedInstance().sessionStore
                if let userId = sessionStore.session()?.userID {
                    sessionStore.logOutUserID(userId)
                }
                Digits.sharedInstance().logOut()
                
                // Remove user information for any upcoming crashes in Crashlytics.
                Crashlytics.sharedInstance().setUserIdentifier(nil)
                Crashlytics.sharedInstance().setUserName(nil)
                
                // Log Answers Custom Event.
                Answers.logCustomEvent(withName: "Signed Out", customAttributes: nil)
                
                // Set Guest Login to false
                UserDefaults.standard.set(false, forKey: "guestLoggedIn")
                
                // Present the Login Screen again
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginViewController, animated: true, completion: nil)
            }
        }
    }
    
    // MARK: Helpers
    func deletePinInfo(deleteCompletionStatus: @escaping(_ success: Bool) -> Void) {
        
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            for pin in pins {
                AppDelegate.stack.context.delete(pin)
                AppDelegate.stack.save()
            }
            deleteCompletionStatus(true)
        }
    }
    // MARK: TableView Data Source
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let venue = fetchedResultsController?.object(at: indexPath) as! Pin
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PinTableCell", for: indexPath)
        let count = Int(venue.checkinsCount)
        
        cell.textLabel?.text = venue.name
        cell.detailTextLabel?.text = "Checkin count is \(count)"
        
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
