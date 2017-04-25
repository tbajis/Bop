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
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        loadMapPins()
    }
    
    // Helpers
    func loadMapPins() {
        /* TODO: Set a conditional statement that will execute in this fashion if pins have been loaded */
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
    func displayError(_ error: String?) {
        
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
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
