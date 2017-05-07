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
import CoreLocation

class BopMapViewController: UIViewController, FoursquareRequestType, CLLocationManagerDelegate {
    
    // MARK: Properties
    // Create an instance of CLLocationManager to track user's location
    let locationManager = CLLocationManager()
    
    // Create objects for mapView span and region
    var span: MKCoordinateSpan?
    var region: MKCoordinateRegion?
    var userLocation: CLLocation?
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
 
        mapView.delegate = self
        loadMapRegion()
        configureMapWithPins() { (success) in
            if success {
                self.placePinsOnMap()
            } else {
                self.displayError("An error occured placing pins on the map")
            }
        }
        print("ViewDidLoad called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    // MARK: Actions
    @IBAction func searchWithLocation(_ sender: UIButton) {
        /* TODO: Implement getVenuesBySearch for user's current location */
        
    }
    
    @IBAction func launchInterestPicker(_ sender: UIBarButtonItem) {
        
        if mapView.annotations.count > 0 {
            for annotation in mapView.annotations {
                mapView.removeAnnotation(annotation)
            }
        }
        chooseInterest() {
            self.configureMapWithPins() { (success) in
                if success {
                    self.placePinsOnMap()
                } else {
                    self.displayError("An error occured placing pins on the map")
                }
            }
        }
    }

    @IBAction func presetButtonPressed(_ sender: UIButton) {
        
        CoreDataObject.sharedInstance().executePinSearch()
        configureMapWithPins() { (success) in
            if success {
                self.placePinsOnMap()
            } else {
                self.displayError("An error occured placing pins on the map")
            }
        }

        /*CoreDataObject.sharedInstance().executePinSearch()
        if mapView.annotations.count > 0 {
            self.removePinsFromMap() { (success) in
                if success {
                    print("successfully removed pin and deleted from CoreData")
                    self.configureMapWithPins() { (success) in
                        print("Successfully downloaded and persisted new locations")
                        self.placePinsOnMap()
                    }
                }
            }
        }*/
    }
    
    // Helpers
    func configureMapWithPins(_ configCompletionStatus: @escaping(_ success: Bool) -> Void) {
        
        CoreDataObject.sharedInstance().executePinSearch()
        if CoreDataObject.sharedInstance().interest?.pins?.count == 0 {
            searchForPins(searchCompletionStatus: configCompletionStatus)
        } else {
            configCompletionStatus(true)
        }
    }
    
    func searchForPins(searchCompletionStatus: @escaping(_ success: Bool) -> Void) {
        
        getVenuesBySearch(using: "bars", latitude: 40.7, longitude: -74) { (success, venues, error) in
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
                    let locationCoord = CLLocationCoordinate2DMake(venue.latitude!, venue.longitude!)
                    let pin = Pin(name: venue.name, id: venue.id, latitude: locationCoord.latitude, longitude: locationCoord.longitude, address: "", checkinsCount: venue.checkinsCount!, context: AppDelegate.stack.context)
                    pin.interest = CoreDataObject.sharedInstance().interest
                    AppDelegate.stack.save()
                }
                searchCompletionStatus(true)
            }
        }
    }
    
    private func placePinsOnMap() {
    
        CoreDataObject.sharedInstance().executePinSearch()
        if let interests = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            print("NUMBER OF PINS IS: \(interests.count)")
        } else {
            print("THERE ARE NO PINS")
        }
        var pinsToAdd = [Pin]()
        for pin in CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as! [Pin] {
            pinsToAdd.append(pin)
        }
        mapView.addAnnotations(pinsToAdd)
    }

    func removePinsFromMap(removePinCompletionStatus: @escaping(_ success: Bool) -> Void) {
    
        for annotation in mapView.annotations {
            mapView.removeAnnotation(annotation)
        }
        deletePinInfo(deleteCompletionStatus: removePinCompletionStatus)
    }
    
    func deletePinInfo(deleteCompletionStatus: @escaping(_ success: Bool) -> Void) {
        
        for pin in CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as! [Pin] {
            AppDelegate.stack.context.delete(pin)
            AppDelegate.stack.save()
        }
        deleteCompletionStatus(true)
    }
    
    func loadMapRegion() {
        
        if let region = UserDefaults.standard.object(forKey: "region") as AnyObject? {
            let latitude = region["latitude"] as! CLLocationDegrees
            let longitude = region["longitude"] as! CLLocationDegrees
            let center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            let latDelta = region["latitudeDelta"] as! CLLocationDegrees
            let longDelta = region["longitudeDelta"] as! CLLocationDegrees
            let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: longDelta)
            let updatedRegion = MKCoordinateRegion(center: center, span: span)
            mapView.setRegion(updatedRegion, animated: true)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetailFromMap" {
            let pin = sender as! Pin
            let detailController = segue.destination as! BopDetailViewController
            detailController.pin = pin
        }
    }
    
    // Utilities
    func chooseInterest(_ completion: @escaping () -> Void) {
        
        let interestController = storyboard?.instantiateViewController(withIdentifier: "InterestPickerViewController") as! InterestPickerViewController
        interestController.completionHandlerForDismissal = completion
        present(interestController, animated: true, completion: nil)
    }
    
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
            pinView?.canShowCallout = true
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            let pin = view.annotation as! Pin
            performSegue(withIdentifier: "showDetailFromMap", sender: pin)
        }
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let persistedRegion = [
        "latitude":mapView.region.center.latitude,
        "longitude":mapView.region.center.longitude,
        "latitudeDelta":mapView.region.span.latitudeDelta,
        "longitudeDelta":mapView.region.span.longitudeDelta
        ]
        UserDefaults.standard.set(persistedRegion, forKey: "region")
    }
}

// MARK: - CLLocationManagerDelegate
extension BopMapViewController {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        self.userLocation = location
        self.span = MKCoordinateSpanMake(100, 100)
        let updatedLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.region = MKCoordinateRegionMake(updatedLocation, span!)
        self.mapView.showsUserLocation = true
    }
}
