//
//  Pun.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase

class Pun: FirebaseType {
    
    let body: String
    let submitter: String?
    var reportedCount: Int
    
    private let bodyKey = "body"
    private let submitterKey = "submitter"
    private let reportedCountKey = "reportedCount"
    
    var endpoint: String {
        return "puns"
    }
    
    var identifier: String?
    
    var dictionaryCopy: [String : AnyObject] {
        guard let submitter = submitter else { return [bodyKey: body] }
        return [bodyKey: body, submitterKey: submitter]
    }
    
    init(body: String, reportedCount: Int = 0, identifier: String = NSUUID().UUIDString) {
        self.body = body
        self.reportedCount = reportedCount
        self.submitter = FIRAuth.auth()?.currentUser?.displayName ?? nil
        self.identifier = identifier
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        guard let body = dictionary[bodyKey] as? String,
            reportedCount = dictionary[reportedCountKey] as? Int,
            submitter = dictionary[submitterKey] as? String else { return nil }
        self.body = body
        self.reportedCount = reportedCount
        self.submitter = submitter
        self.identifier = identifier
    }
}