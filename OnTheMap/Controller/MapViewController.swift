//
//  MapViewController.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/24/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewController: UIViewController,MKMapViewDelegate{
    @IBOutlet weak var mapView: MKMapView!
    override func viewWillAppear(_ animated: Bool) {
        let currentLocation = LocationModel.postedLocation
        print("the current location is \(String(describing: currentLocation?.latitude))")
        if currentLocation != nil {
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: currentLocation?.latitude ?? 0, longitude: currentLocation?.longitude ?? 0), animated: true)
            
            // set annotation
            let lat = CLLocationDegrees(currentLocation!.latitude)
            let long = CLLocationDegrees(currentLocation!.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = currentLocation!.firstName
            let last = currentLocation!.lastName
            let mediaURL = currentLocation!.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
    override func viewDidLoad() {
        //set map center
        var locations = LocationModel.latestLocation
        let currentLocation = LocationModel.postedLocation
        if currentLocation != nil {
            locations.append(currentLocation!)
        }
        var annotations = [MKPointAnnotation]()
        for dictionary in locations {
            
            // Notice that the float values are being used to create CLLocationDegree values.
            // This is a version of the Double type.
            let lat = CLLocationDegrees(dictionary.latitude)
            let long = CLLocationDegrees(dictionary.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            let first = dictionary.firstName
            let last = dictionary.lastName
            let mediaURL = dictionary.mediaURL
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(first) \(last)"
            annotation.subtitle = mediaURL
            
            // Finally we place the annotation in an array of annotations.
            annotations.append(annotation)
        }
        self.mapView.addAnnotations(annotations)
        
    }
    @IBAction func logoutButtonPressed(_ sender: Any) {
        OnTheMapClient.logout { (success, error) in
            if error != nil {
                print(String(describing: error))
            } else {
                print("logged out successful")
                self.navigationController?.dismiss(animated: true, completion: nil)
//                self.performSegue(withIdentifier: "fromMapToLogin", sender: nil)
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!, options: [:]) { (success) in
                    //
                }
//                app.openURL(URL(string: toOpen)!)
            }
        }
    }
}
//'[UIApplication.OpenExternalURLOptionsKey : Any]'

