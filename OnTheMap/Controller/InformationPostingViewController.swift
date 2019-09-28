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
class InformationPostingViewController: UIViewController {
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    var Currentlocation:CLLocationCoordinate2D?
    //handle get user info data by calling get user data
    func getLocationHandler(location:CLLocationCoordinate2D?,error:Error?)->Void{
        guard let location = location else {
            print("error location not found")
            let alert = UIAlertController(title: "Error", message: "error location not found", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        print("get location successful with location\(location.latitude) \(location.longitude)")
        self.Currentlocation = location
        OnTheMapClient.getUserData(completion: getUserDataHandler(userData:error:))
    }
    //post location after getting the data successfully
    func getUserDataHandler(userData:GetUserInfoResponse?,error:Error?)->Void{
        guard let userData = userData else {
            print("user info not found")
            return
        }
        print("user data has been found firstname:\(userData.firstName) lastname:\(userData.lastName)")
        OnTheMapClient.postLocation(studentInfo: userData, location: self.Currentlocation!, mediaURL: linkTextField.text!, mapString: locationTextField.text!) { (success, error) in
            if success {
                print ("post location data successful")
                DispatchQueue.main.async {
                    OnTheMapClient.getLocation(completion: { (success, error) in
                        if success {
                            print("list of users updated")
                        } else {
                            print("error requesting users \(String(describing: error))")
                        }
                    })
                    self.navigationController?.popToRootViewController(animated: true)
                }
            } else {
                print("post data unsuccessful \(String(describing: error))")
                // popup
                let alert = UIAlertController(title: "Error", message: String(describing: error), preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    @IBAction func submitButtonPressed(_ sender: Any) {
        OnTheMapClient.getLocationFromString(address: locationTextField.text ?? "", completion: getLocationHandler(location:error:))
        
        //action here
    }
    override func viewDidLoad() {
        //
    }
}
