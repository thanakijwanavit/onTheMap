//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/22/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
struct LoginResponse: Codable {
    let account: Account
    let session: SessionResponse
}

