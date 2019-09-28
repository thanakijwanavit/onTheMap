//
//  GetUserInfoResponse.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/26/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//{

import Foundation
//struct GetUserInfoResponse: Codable{
//    let user:User
//}
//struct User: Codable{
//    let lastName: String
//    let firstName: String
//    enum CodingKeys: String, CodingKey {
//        case lastName = "last_name"
//        case firstName = "first_name"
//    }
//}
struct GetUserInfoResponse: Codable{
    let lastName: String
        let firstName: String
        enum CodingKeys: String, CodingKey {
            case lastName = "last_name"
            case firstName = "first_name"
        }
}
