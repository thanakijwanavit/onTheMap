//InformationPostingViewController
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/25/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        submitButton.isHidden = true
    }
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        self.findingLocation(false)
        //
    }
    
    
    var Currentlocation:CLLocationCoordinate2D?
    
    
    //handle get user info data by calling get user data
    func getLocationHandler(location:CLLocationCoordinate2D?,error:Error?)->Void{
        guard let location = location else {
            print("error location not found")
            self.findingLocation(false)
            let alert = UIAlertController(title: "Error", message: "error location not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("get location successful with location\(location.latitude) \(location.longitude)")
        self.Currentlocation = location
        self.findingLocation(false)
        submitButton.isHidden = false
        
        
        print("map region is set")
        self.setAnnotation(currentLocation: location, firstName: LocationModel.userInfo!.firstName, lastName: LocationModel.userInfo!.lastName, mediaURL: linkTextField.text ?? "")
        
        let region = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05))
        mapView.setRegion(region, animated: true)
    }
    
    //post location after getting the data successfully
    func getUserDataHandler(userData:GetUserInfoResponse?,error:Error?)->Void{
        guard let userData = userData else {
            print("user info not found")
            self.submittingLocation(false)
            return
        }
        print("user data has been found firstname:\(userData.firstName) lastname:\(userData.lastName)")
        submitLocation(userData: userData, location: self.Currentlocation)
        
    }
    
    func submitLocation(userData:GetUserInfoResponse?, location:CLLocationCoordinate2D?){
        OnTheMapClient.postLocation(studentInfo: userData!, location: self.Currentlocation!, mediaURL: linkTextField.text!, mapString: locationTextField.text!) { (success, error) in
            if success {
                print ("post location data successful")
                DispatchQueue.main.async {
                    OnTheMapClient.getLocation(completion: { (success, error) in
                        if success {
                            print("list of users updated")
                            self.navigationController?.popToRootViewController(animated: true)
                        } else {
                            print("error requesting users \(String(describing: error))")
                        }
                    })
                    self.submittingLocation(false)
                }
            } else {
                self.submittingLocation(false)
                print("post data unsuccessful \(String(describing: error))")
                // popup
                let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    @IBAction func findLocationButtonPressed(_ sender: Any) {
        self.findingLocation(true)
        OnTheMapClient.getLocationFromString(address: locationTextField.text ?? "", completion: getLocationHandler(location:error:))
        
        //action here
    }
    
    
    
    @IBAction func submitButtonPressed(_ sender: Any) {
        self.submittingLocation(true)
        OnTheMapClient.getUserData(completion: getUserDataHandler(userData:error:))
    
    }
    
    func findingLocation(_ posting: Bool){
        if posting{
            activityIndicator.startAnimating()
            findLocationButton.isHidden = true
        } else {
            activityIndicator.stopAnimating()
            findLocationButton.isHidden = false
        }
    }
    func submittingLocation(_ posting: Bool){
        if posting{
            activityIndicator.startAnimating()
            submitButton.isHidden = true
        } else {
            activityIndicator.stopAnimating()
        }
    }
    
    
    func setAnnotation(currentLocation:CLLocationCoordinate2D?,firstName:String,lastName:String,mediaURL:String){
        if currentLocation != nil {
            self.mapView.setCenter(CLLocationCoordinate2D(latitude: currentLocation?.latitude ?? 0, longitude: currentLocation?.longitude ?? 0), animated: true)
            
            // set annotation
            let lat = CLLocationDegrees(currentLocation!.latitude)
            let long = CLLocationDegrees(currentLocation!.longitude)
            
            // The lat and long are used to create a CLLocationCoordinates2D instance.
            let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
            
            
            // Here we create the annotation and set its coordiate, title, and subtitle properties
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            annotation.title = "\(firstName) \(lastName)"
            annotation.subtitle = mediaURL
            self.mapView.addAnnotation(annotation)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}




extension InformationPostingViewController: MKMapViewDelegate{
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
                }
            }
        }
}
