//
//  Pun.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase

class Pun: FirebaseType, Equatable {
    
    let body: String
    var submitter: String?
    var reportedCount: Int
    
    fileprivate let bodyKey = "body"
    fileprivate let submitterKey = "submitter"
    fileprivate let reportedCountKey = "reportedCount"
    
    var endpoint: String {
        return "puns"
    }
    
    var identifier: String?
    
    var dictionaryCopy: [String : AnyObject] {
        guard let submitter = submitter else { return [bodyKey: body as AnyObject] }
        return [bodyKey: body as AnyObject, reportedCountKey: reportedCount as AnyObject, submitterKey: submitter as AnyObject]
    }
    
    init(body: String, reportedCount: Int = 0, identifier: String = UUID().uuidString) {
        self.body = body
        self.reportedCount = reportedCount
        self.submitter = FIRAuth.auth()?.currentUser?.displayName ?? nil
        self.identifier = identifier
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        guard let body = dictionary[bodyKey] as? String,
        let reportedCount = dictionary[reportedCountKey] as? Int,
            let submitter = dictionary[submitterKey] as? String else { return nil }
        self.body = body
        self.reportedCount = reportedCount
        self.submitter = submitter
        self.identifier = identifier
    }
}

func ==(lhs: Pun, rhs: Pun) -> Bool {
    return lhs.identifier == rhs.identifier
}
