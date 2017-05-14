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
    var interest = UserDefaults.standard.object(forKey: "Interest") as? String
    
    // Create an instance of CLLocationManager to track user's location
    let locationManager = CLLocationManager()
    
    // Create objects for mapView span and region
    var span: MKCoordinateSpan?
    var region: MKCoordinateRegion?
    var userLocation: CLLocation?
    let dcLocationCenter = CLLocationCoordinate2D(latitude: 40.7, longitude: -74)
    let dcLocationSpan = MKCoordinateSpan(latitudeDelta: 0.25, longitudeDelta: 0.25)
    
    // MARK: Outlets
    @IBOutlet weak var mapView: MKMapView!
    
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMapRegion()
        configureMapWithPins() { (success) in
            if success {
                self.placePinsOnMap()
            } else {
                self.displayError("An eror occured placing pins on the map")
            }
        }
 
        
//        mapView.delegate = self
//        loadMapRegion()
//        configureMapWithPins() { (success) in
//            if success {
//                self.loadRegionFromSearch(self.dcLocationCenter, self.dcLocationSpan)
//                self.placePinsOnMap()
//            } else {
//                self.displayError("An error occured placing pins on the map")
//            }
//        }
//        print("ViewDidLoad called")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    
    // MARK: Actions
    @IBAction func searchWithLocation(_ sender: UIButton) {
        /* TODO: Implement getVenuesBySearch for user's current location */
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        locationManager.startUpdatingLocation()

        
    }

    @IBAction func presetButtonPressed(_ sender: UIButton) {
        
        CoreDataObject.sharedInstance().executePinSearch()
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            print("PINS REMAINING: \(pins.count)")
        }
    }
    
    @IBAction func refresh() {
        
        removePinsFromMap() { (success) in
            if success {
                /* TODO: FETCH NEW PINS */
            }
        }
    }
    
    // Helpers
    func configureMapWithPins(_ configCompletionStatus: @escaping(_ success: Bool) -> Void) {
        
        guard (UserDefaults.standard.object(forKey: "Interest")) != nil else {
            print("An error occured in which there is no interest stored!")
            /* TODO: DISPLAY AN ERROR */
            return
        }
        CoreDataObject.sharedInstance().executePinSearch()
        guard let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin], pins.count > 0 else {
            searchForPins(searchCompletionStatus: configCompletionStatus)
            return
        }
        configCompletionStatus(true)
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
                    let _ = Pin(name: venue.name, id: venue.id, latitude: locationCoord.latitude, longitude: locationCoord.longitude, address: "", checkinsCount: venue.checkinsCount!, context: AppDelegate.stack.context)
                    AppDelegate.stack.save()
                }
                searchCompletionStatus(true)
            }
        }
    }
    
    private func placePinsOnMap() {
        
        CoreDataObject.sharedInstance().executePinSearch()
        var pinsToAdd = [Pin]()
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            print("NUMBER OF PINS IS: \(pins.count)")
            for pin in pins {
                pinsToAdd.append(pin)
            }
        } else {
            print("THERE ARE NO PINS")
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
        
        if let pins = CoreDataObject.sharedInstance().fetchedPinResultsController.fetchedObjects as? [Pin] {
            for pin in pins {
                AppDelegate.stack.context.delete(pin)
                AppDelegate.stack.save()
            }
        }
        deleteCompletionStatus(true)
    }
    
    func loadRegionFromSearch(_ center: CLLocationCoordinate2D, _ span: MKCoordinateSpan) {
        
        let region = MKCoordinateRegion(center: center, span: span)
        mapView.setRegion(region, animated: true)
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
    func displayError(_ error: String?) {
        
        let alertController = UIAlertController(title: "Error", message: error, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate
extension BopMapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isMember(of: MKUserLocation.self) {
            return nil
        }
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
        self.span = MKCoordinateSpanMake(0.25, 0.25)
        let updatedLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        self.region = MKCoordinateRegionMake(updatedLocation, span!)
        self.mapView.showsUserLocation = true
    }
}
