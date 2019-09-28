//
//  OnTheMapClient.swift
//  OnTheMap
//
//  Created by nic Wanavit on 9/21/19.
//  Copyright © 2019 Wanavit. All rights reserved.


import Foundation
import UIKit
import CoreLocation
class OnTheMapClient {
    struct Auth {
        static var accountId = ""
        static var requestToken = ""
        static var sessionId = ""
        static var apiKey = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        static let apiKeyParam = "?api_key=\(OnTheMapClient.Auth.apiKey)"
        
        case getRequestToken
        case login
        case putLocation(String)
        case studentLocation
        case getPublicUserProfile(String)
        case postLocation
        
        var stringValue: String {
            switch self {
            case .getRequestToken: return Endpoints.base + "/authentication/token/new" + Endpoints.apiKeyParam + "&session_id=\(Auth.sessionId)"
            case .login: return Endpoints.base + "/session"
            case .putLocation(let objectId): return "https://onthemap-api.udacity.com/v1/StudentLocation/" + objectId
            case .studentLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
            case .getPublicUserProfile(let userId): return "https://onthemap-api.udacity.com/v1/users/" + userId
            case .postLocation: return "https://onthemap-api.udacity.com/v1/StudentLocation"
                }
            }
        var url: URL {
            return URL(string: stringValue)!
            }
        }
    
    
    ////custom func
    
    class func login(username:String, password: String, completion: @escaping (Bool,Error?)->Void){
        let body = LoginObject(udacity: loginKey(username: username, password: password))
        taskForPOSTRequestSecure(url: Endpoints.login.url, responseType: LoginResponse.self, errorResponseType: OnTheMapResponse.self, body: body) { (responseObject, error) in
            guard let responseObject = responseObject else {
                completion(false, error)
                print("error decoding response object")
                return
            }
            guard let key = responseObject.account.key else {
                completion(false, error)
                return
            }
            guard let registered = responseObject.account.registered else {
                completion(false, error)
                return
            }
            OnTheMapClient.Auth.accountId = key
            print(" the sessionid is \(OnTheMapClient.Auth.accountId)")
            if registered {
                completion(true, nil)
            } else {
                completion(false, nil)
            }
        }
    }
    
    class func getLocation(completion: @escaping (Bool, Error?)->Void){
        taskForGet(url: Endpoints.studentLocation.url, responseType: GetLocationResponse.self) { (studentArray, error) in
            guard let studentArray = studentArray else {
                print("response student empty")
                completion(false,error)
                return
            }
            DispatchQueue.main.async {
                LocationModel.latestLocation = studentArray.results
                completion(true,nil)
            }
        }
    }
    class func getLocationFromString(address:String, completion: @escaping (CLLocationCoordinate2D?, Error?)-> Void)  {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemark, error) in
            guard let placemark = placemark else {
//                print("error location not found")
                completion(nil, error)
                return
            }
        let location = placemark[0].location
        let coordinate = location?.coordinate
        completion(coordinate, nil)
        }
    }
    class func postLocation(studentInfo:GetUserInfoResponse, location:CLLocationCoordinate2D,mediaURL:String, mapString:String, completion: @escaping (Bool, Error?)->Void){
        let firstName = studentInfo.firstName
        let lastName = studentInfo.lastName
        
        let student = PostLocationRequest(uniqueKey: OnTheMapClient.Auth.accountId, firstName: firstName, lastName: lastName, mapString: mapString, mediaURL: mediaURL, latitude: location.latitude, longitude: location.longitude)
        taskForPOSTRequest(url: Endpoints.postLocation.url, responseType: PostLocationResponse.self , body: student) { (objectData, error) in
            guard objectData != nil else {
                print ("post location has failed")
                completion(false,error)
                return
            }
            completion(true,nil)
        }
        
    }
//
    class func getUserData(completion: @escaping (GetUserInfoResponse?, Error?)->Void){
        let url = Endpoints.getPublicUserProfile(String(OnTheMapClient.Auth.accountId)).url
        taskForGetSecure(url: url, responseType: GetUserInfoResponse.self) { (userInfo, error) in
            guard let userInfo = userInfo else {
                print(error as Any)
                completion(nil,error)
                return
            }
            completion(userInfo,nil)
        }
    }
    
//    class func putLocation(completion: @escaping (Bool, Error?)->Void){
//        taskForPUTRequest(url: Endpoints.putLocation(self.Auth), responseType: <#T##Decodable.Protocol#>, body: <#T##Encodable#>, completion: <#T##(Decodable?, Error?) -> Void#>)
//    }
    //general task functions for get and post requests
    class func taskForGet <ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?)->Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    class func taskForGetSecure <ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, completion: @escaping (ResponseType?, Error?)->Void){
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data?.dropFirst(5) else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            }
            catch {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequestSecure<RequestType: Encodable, ResponseType: Decodable,ErrorResponseType: Decodable>(url: URL, responseType: ResponseType.Type,errorResponseType: ErrorResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data?.dropFirst(5) else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponseType.self, from: data) as! Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPOSTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func taskForPUTRequest<RequestType: Encodable, ResponseType: Decodable>(url: URL, responseType: ResponseType.Type, body: RequestType, completion: @escaping (ResponseType?, Error?) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = try! JSONEncoder().encode(body)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data?.dropFirst(5) else {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(ResponseType.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(OnTheMapResponse.self, from: data) as Error
                    DispatchQueue.main.async {
                        completion(nil, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(nil, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    /// Get dummy data
    class func getDummy(){
        let decoder = JSONDecoder()
        let data = try! JSONSerialization.data(withJSONObject: DummyData.dummyJson, options: .prettyPrinted)
        let dummyJson = try! decoder.decode([Student].self, from: data)
        LocationModel.latestLocation.append(contentsOf: dummyJson)
        print(LocationModel.latestLocation)
    }
}
