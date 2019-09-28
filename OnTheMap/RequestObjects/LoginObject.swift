//
//  LoginObject.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/21/19.
//  Copyright © 2019 Wanavit. All rights reserved.
//

import Foundation
struct LoginObject: Codable{
    let udacity: loginKey
    
}

struct loginKey: Codable{
    let username: String
    let password: String
}
