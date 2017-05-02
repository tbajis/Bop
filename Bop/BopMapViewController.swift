//
//  BopMapViewController.swift
//  Bop
//
//  Created by Thomas Manos Bajis on 4/17/17.
//  Copyright © 2017 Thomas Manos Bajis. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit

class BopMapViewController: UIViewController, FoursquareRequestType {
    
    // MARK: Properties
    // Create a fetchedResultsController to retrieve and monitor changes in CoreDataModel
    lazy var fetchedResultsController: NSFetchedResultsController<NSFetchRequestResult>? = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Interest")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "category", ascending: true)]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: AppDelegate.stack.context, sectionNameKeyPath: nil, cacheName: nil)
        return fetchedResultsController
    }()

    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        executeSearch()
        if let interests = fetchedResultsController?.fetchedObjects as? [Interest], interests.count > 0 {
            for interest in interests {
                if let pins = interest.pins?.count, pins > 0 {
                    loadPersistedLocations()
                } else {
                    loadMapPins()
                }
            }
            loadPersistedLocations()
        } else {
            navigateToInterestPicker()
        }
    }
    
    // Helpers
    func loadPersistedLocations() {
    
        guard let interests = fetchedResultsController?.fetchedObjects as? [Interest] else {
            print("An error occured loading persisted pins")
            return
        }
        for interest in interests {
            guard let pins = interest.pins as? [Pin] else {
                print("No pins found for interst")
                return
            }
            for pin in pins {
                let lat = CLLocationDegrees(pin.latitude)
                let lon = CLLocationDegrees(pin.longitude)
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                let venueName = pin.name
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinate
                annotation.title = venueName
                self.mapView.addAnnotation(annotation)
            }
        }
    }
    
    func loadMapPins() {
        
        getVenuesBySearch(using: "movies", latitude: 40.7, longitude: -74) { (success, venues, error) in
            performUIUpdatesOnMain {
                guard success else {
                    self.displayError(error)
                    return
                }
                guard let venues = venues else {
                    self.displayError(FoursquareConstants.Error.Data)
                    return
                }
                for venue in venues {
                    /* TODO: Create a Pin object and reference it to create an MKPointAnnotation */
                    let lat = CLLocationDegrees(venue.latitude!)
                    let lon = CLLocationDegrees(venue.longitude!)
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let venueName = venue.name
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = venueName
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }

    // Utilities
    func navigateToInterestPicker() {
        
        let interestController = storyboard?.instantiateViewController(withIdentifier: "InterestPickerViewController") as! InterestPickerViewController
        present(interestController, animated: true, completion: nil)
    }
    
    func displayError(_ error: String?) {
        
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
}

// MARK: - MKMapViewDelegate
extension BopMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
    }
}

// MARK: - NSFetchedResultsControllerDelegate
extension BopMapViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    }
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    }
}
