//
//  UdacityErrorResponse.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/29/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
struct UdacityErrorResponse: Codable {
    let status:Int
    let error: String

}
extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return error
    }
}
