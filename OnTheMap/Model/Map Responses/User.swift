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
struct UserData: Codable {
    var user: UserDatas
}
struct UserDatas: Codable {
    var lastName: String
    var socialAccounts: [String]
    var mailingAddress: String
    var facebookID: String
    var timezone: String
    var sitePreferences: String
    var occupation: String
    var firstName: String
    var key: String
    var nickname: String
    var imageURL: String
}

