//
//  POSTSessionResponse.swift
//  OnTheMap
//
//  Created by Faisal Babkoor on 11/14/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import Foundation
struct POSTSessionResponse: Codable {
    var account: AccountResponse
    var session: SessionResponse
}
