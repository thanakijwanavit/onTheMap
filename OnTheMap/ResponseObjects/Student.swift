//
//  Student.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/21/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//








import Foundation
struct Student: Codable, Equatable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String?
    let latitude: Double
    let longitude: Double
    let createdAt: String
    let updatedAt: String
    
}
