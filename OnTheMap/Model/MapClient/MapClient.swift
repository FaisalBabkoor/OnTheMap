//
//  MapClient.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import Foundation
class MapClient {
    struct AuthUser {
        static var key = ""
        static var objectId = ""
    }
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        // GET
        case limit(Int)
        case skip(Int, Int)
        case order
        case limitAndSkipAndOrder(Int, Int)
        case uniqueKey(String)
        case getAllStuedntLocation
        case getPublicUserData(Int)
        //POST
        case createNewStudentLocation
        case createSessionID
        //PUT
        case updateStudentLocation(String)
        //Delete
        case deleteSession
        var stringValue: String {
            switch self {
            case let .limit(limit):
                return Endpoints.base + "/StudentLocation?limit=\(limit)"
            case let .skip(limit,skip):
                return Endpoints.base + "/StudentLocation?limit=\(limit)&skip=\(skip)"
            case .order:
                return Endpoints.base + "/StudentLocation?order=-updatedAt"
            case let .limitAndSkipAndOrder(limit,skip):
                return Endpoints.base + "/StudentLocation?limit=\(limit)&skip=\(skip)&order=-updatedAt"
                
            case let .uniqueKey(uniqueKey):
                return Endpoints.base + "https://onthemap-api.udacity.com/v1/StudentLocation?uniqueKey=\(uniqueKey)"
            case .getAllStuedntLocation:
                return Endpoints.base + "/StudentLocation"
            case .createNewStudentLocation:
                return Endpoints.base + "/StudentLocation"
            case let .updateStudentLocation(objectID):
                return Endpoints.base + "/StudentLocation/\(objectID)"
            case .createSessionID:
                return Endpoints.base + "/session"
            case .deleteSession:
                return Endpoints.base + "/session"
            case let .getPublicUserData(userid):
                return Endpoints.base + "/users/\(userid)"
            }
        }
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    
    
    class func getStudentLocation(limit: Int = 100, skip: Int = 0, completion: @escaping (UsersInfo?, Error?)->Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: Endpoints.limitAndSkipAndOrder(limit, skip).url) { data, response, error in
            var usersLocation: [RequestStudentLocation] = []
            if error != nil { // Handle error...
                completion(nil, error!)
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode >= 200 && response.statusCode < 300 {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                do {
                    let userInfo = try decoder.decode(UsersInfo.self, from: data)
                    usersLocation = userInfo.results
                    
                    
                } catch {
                    completion(nil, error)
                }
                //                  print(String(data: data, encoding: .utf8)!)
                
            }else {
                completion(nil,error!)
            }
            DispatchQueue.main.async {
                completion(UsersInfo(results: usersLocation), nil)
            }
        }
        task.resume()
    }
    //POST
    class func createNewStudentLocation(location: RequestStudentLocation, completion: @escaping (String?)->Void) {
        var errorMessage: String?
        var request = URLRequest(url: Endpoints.createNewStudentLocation.url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(location.uniqueKey ?? "0")\", \"firstName\": \"\(location.firstName ?? "")\", \"lastName\": \"\(location.lastName ?? "")\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0.0), \"longitude\": \(location.longitude ?? 0.0)}".data(using: .utf8)
        print("{\"uniqueKey\": \"\(AuthUser.key)\", \"firstName\": \"\(location.firstName ?? "")\", \"lastName\": \"\(location.lastName ?? "")\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0.0), \"longitude\": \(location.longitude ?? 0.0)}")
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                errorMessage = error?.localizedDescription
                completion(errorMessage)
                return
            }
            guard let data = data else { return }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode >= 200 && response.statusCode < 300 {
                let decoder = JSONDecoder()
                do {
                    let createLocation = try decoder.decode(CreateStudenLocationResponse.self, from: data)
                    AuthUser.objectId = createLocation.objectId
                } catch {
                    errorMessage = error.localizedDescription
                }
            } else {
                errorMessage = error?.localizedDescription
            }
            
            print(String(data: data, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                completion(errorMessage)
            }
        }
        task.resume()
    }
    
    func updateStudentLocation(location: RequestStudentLocation, completion: @escaping (String?)->Void) {
        
        let urlString = "https://onthemap-api.udacity.com/v1/StudentLocation/8ZExGR5uX8"
        let url = URL(string: urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(location.uniqueKey ?? "")\", \"firstName\": \"\(location.firstName ?? "")\", \"lastName\": \"\(location.lastName ?? "")\",\"mapString\": \"\(location.mapString ?? "")\", \"mediaURL\": \"\(location.mediaURL ?? "")\",\"latitude\": \(location.latitude ?? 0.0), \"longitude\": \(location.longitude ?? 0.0)}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
        
    }
    
    class func crateSessionID(username: String, password: String, completion: @escaping (String?) -> ()) {
        var errorMessage: String?
        var request = URLRequest(url: Endpoints.createSessionID.url)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        //          encoding a JSON body from a string, can also use a Codable struct
        request.httpBody = "{\"udacity\": {\"username\": \"\(username)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                
                errorMessage = error!.localizedDescription
                completion(errorMessage)// Handle error…
                return
            }
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode >= 200 && response.statusCode < 300 {
                //           let range = Range(5..<data!.count)
                let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
                //                print(String(data: newData!, encoding: .utf8)!)
                guard let newdata = newData else { return }
                let decoder = JSONDecoder()
                do {
                    let session = try decoder.decode(POSTSessionResponse.self, from: newdata)
                    print(session)
                    AuthUser.key = session.account.key
                } catch {
                    errorMessage = "try agian"
                }
            } else {
                errorMessage = "Check your internet connection"
            }
            DispatchQueue.main.async {
                completion(errorMessage)
            }
            
        }
        task.resume()
        
    }
    //Done 👍🏻
    
    class func logout(completion: @escaping (Bool, Error?) -> ()) {
        
        var request = URLRequest(url: Endpoints.deleteSession.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error…
                completion(false, error)
                return
            }
            
            //         let range = Range(5..<data!.count)
            let newData = data?.subdata(in: 5..<data!.count) /* subset response data! */
            print(String(data: newData!, encoding: .utf8)!)
            guard let newdata = newData else { return }
            do {
                var logoutSession =  try JSONDecoder().decode(DeleteSession.self, from: newdata)
                logoutSession.session.id = ""
                logoutSession.session.expiration = ""
                DispatchQueue.main.async {
                    completion(true,nil)
                }
                
            } catch {
                completion(false, error)
            }
        }
        task.resume()
        
    }
    
    
    
    class func getPublicUserData(userId: Int, completion: @escaping (UserData?, Error?) -> ()) {
        
        let request = URLRequest(url: Endpoints.getPublicUserData(userId).url)
        //         let request = URLRequest(url: URL(string: "https://onthemap-api.udacity.com/v1/users/3903878747")!)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil { // Handle error...
                completion(nil, error)
                return
            }
            var userdata: UserData?
            guard let data = data else { return }
            let newData = data.subdata(in: 5..<data.count)
            guard let response = response as? HTTPURLResponse else { return }
            if response.statusCode >= 200 && response.statusCode < 300 {
                let decoder = JSONDecoder()
                do {
                    let user = try decoder.decode(UserData.self, from: newData)
                    userdata = user
                } catch {
                    completion(nil, error)
                }
            }else {
                completion(nil, error)
            }
            //         let range = Range(5..<data!.count)
            /* subset response data! */
            print(String(data: newData, encoding: .utf8)!)
            
            DispatchQueue.main.async {
                completion(userdata, nil)
            }
        }
        task.resume()
        
        
    }
}
