//
//  User.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import Foundation

struct User: Codable {
    var key: String
    var firstName: String
    var lastName: String
}
//String, CodingKey

struct UserData: Codable {
    var lastName: String?
    var firstName: String?
    var key: String?
    var nickname: String?
    
    enum CodingKeys: String, CodingKey {
        case lastName = "first_name"
        case firstName = "last_name"
        case key
        case nickname
       
}
}
