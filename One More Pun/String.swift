//
//  String.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 3/30/17.
//  Copyright © 2017 Areios. All rights reserved.
//

import Foundation

extension String {
    
    /*
     Model Keys
     */
    static var bodyKey: String { get { return "body" } }
    static var submitterKey: String { get { return "submitter" } }
    static var reportedCountKey: String { get { return "reportedCount" } }
    static var upvoteIdentifiersDictionaryKey: String { get { return "upvoteIdentifiersDictionary" } }
    static var downvoteIdentifiersDictionary: String { get { return "downvoteIdentifiersDictionary" } }
    
    static var emailKey: String { get { return "email" } }
    static var usernameKey: String { get { return "username" } }
    
    /*
     Type Keys
     */
    static var punsTypeKey: String { get { return "puns" } }
    static var usersTypeKey: String { get { return "users" } }
}
