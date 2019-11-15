//
//  RequestStudentLocation.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import Foundation
struct RequestStudentLocation: Codable {
    var firstName: String?
    var lastName: String?
    var longitude: Double?
    var latitude: Double?
    var mapString: String?
    var mediaURL: String?
    var uniqueKey: String?
    var objectId: String?
    var createdAt: String?
    var updatedAt: String?
}
struct UsersInfo: Codable {
    var results: [RequestStudentLocation] = []
}
