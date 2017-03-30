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
    var upvoteIdentifiersArray: [String]
    var downvoteIdentifiersArray: [String]
    
    var upvoteCount: Int {
        return upvoteIdentifiersArray.count
    }
    
    var downvoteCount: Int {
        return downvoteIdentifiersArray.count
    }
    
    var endpoint: String {
        return .punsTypeKey
    }
    
    var identifier: String?
    
    var dictionaryCopy: [String : AnyObject] {
        guard let submitter = submitter else { return [.bodyKey: body as AnyObject] }
        return [.bodyKey: body as AnyObject, .submitterKey: submitter as AnyObject]
    }
    
    init(body: String, upvoteIdentifiersArray: [String] = [], downvoteIdentifiersArray: [String] = [], identifier: String = UUID().uuidString) {
        self.body = body
        self.upvoteIdentifiersArray = upvoteIdentifiersArray
        self.downvoteIdentifiersArray = downvoteIdentifiersArray
        self.submitter = FIRAuth.auth()?.currentUser?.displayName ?? nil
        self.identifier = identifier
    }
    
    required init?(dictionary: [String : AnyObject], identifier: String) {
        guard let body = dictionary[.bodyKey] as? String,
        let upvoteIdentifiersDictionary = dictionary[.upvoteIdentifiersDictionaryKey] as? [String: Int],
        let downvoteIdentifiersDictionary = dictionary[.upvoteIdentifiersDictionaryKey] as? [String: Int],
            let submitter = dictionary[.submitterKey] as? String else { return nil }
        let upvoteIdentifiersArray = upvoteIdentifiersDictionary.flatMap { $0.key }
        let downvoteIdentifiersArray = downvoteIdentifiersDictionary.flatMap { $0.key }
        self.body = body
        self.upvoteIdentifiersArray = upvoteIdentifiersArray
        self.downvoteIdentifiersArray = downvoteIdentifiersArray
        self.submitter = submitter
        self.identifier = identifier
    }
}

func ==(lhs: Pun, rhs: Pun) -> Bool {
    return lhs.identifier == rhs.identifier
}
