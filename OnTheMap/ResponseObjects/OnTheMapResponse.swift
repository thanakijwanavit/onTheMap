//
//  OnTheMapResponse.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/21/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
struct OnTheMapResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status_code"
        case statusMessage = "status_message"
    }
}

extension OnTheMapResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
//
