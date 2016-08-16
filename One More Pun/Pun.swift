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
    var reportedDict: [String: String]
    var reportedCount: Int {
        var keys = [Int]()
        for key in reportedDict.keys {
            keys.append(Int(key) ?? 0)
        }
        var count = 0
        for key in keys {
            if key > count {
                count = key
            }
        }
        return count
    }
    
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
    
    init(body: String, reportedCount: [String: String] = [:], identifier: String = NSUUID().UUIDString) {
        self.body = body
        self.reportedDict = reportedCount
        self.submitter = FIRAuth.auth()?.currentUser?.displayName ?? nil
        self.identifier = identifier
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        guard let body = dictionary[bodyKey] as? String,
        reportedCount = dictionary[reportedCountKey] as? [String: String],
            submitter = dictionary[submitterKey] as? String else { return nil }
        self.body = body
        self.reportedDict = reportedCount
        self.submitter = submitter
        self.identifier = identifier
    }
}