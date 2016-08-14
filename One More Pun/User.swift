//
//  User.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation

class User {
    
    let name: String
    let email: String
    let uuid: NSUUID
    private let nameKey = "Name"
    private let emailKey = "Email"
    private let uuidKey = "UUID"
    
    init?(json: [String: AnyObject]) {
        guard let name = json[nameKey] as? String,
            email = json[emailKey] as? String,
            uuid = json[uuidKey] as? NSUUID else { return nil }
        self.name = name
        self.email = email
        self.uuid = uuid
    }
}