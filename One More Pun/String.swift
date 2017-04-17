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
    
    /*
     UI Keys
     */
    static var randomModeOnKey: String { get { return "Random Mode on" } }
    static var randomModeOffKey: String { get { return "Random Mode off" } }
    
    /*
     UserDefaults Keys
     */
    static var launchCountKey: String { get { return "launchCount" } }
    static var sawRandomInfoPopupKey: String { get { return "sawRandomInfoPopup" } }
    static var randomOrTopKey: String { get { return "randomOrTop" } }
    
    /*
     Storyboard Keys
     */
    static var mainStoryboardNameKey: String { get { return "Main" } }
    static var loginViewControllerIDKey: String { get { return "LoginViewController" } }
    
    /*
     Misc
     */
    static var imageCommentKey: String { get { return "Shared via One More Pun!\nniclaughter.com/OneMorePun" } }
}
