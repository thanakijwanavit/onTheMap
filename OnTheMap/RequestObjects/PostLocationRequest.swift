//
//  PostLcoationRequest.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/25/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//
//{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Mountain View, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.386052, \"longitude\": -122.083851}
import Foundation
struct PostLocationRequest: Codable{
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
