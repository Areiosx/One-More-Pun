//
//  FirebaseController.swift
//  FamilyTime
//
//  Created by Nicholas Laughter on 6/8/16.
//  Copyright © 2016 Nicholas Laughter. All rights reserved.
//

import Foundation
import Firebase

class FirebaseController {
    
    static let shared = FirebaseController()
    static let ref = FIRDatabase.database().reference()
    
    func getLoggedInUser(completion: (user: FIRUser?) -> Void) {
        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
            if let user = user {
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
}

protocol FirebaseType {
    
    var endpoint: String { get }
    var identifier: String? { get set }
    var dictionaryCopy: [String: AnyObject] { get }
    
    init?(dictionary: [String: AnyObject], identifier: String)
    
    mutating func save()
    func delete()
}

extension FirebaseType {
    
    mutating func save() {
        var newEndpoint = FirebaseController.ref.child(endpoint)
        if let identifier = identifier {
            newEndpoint = newEndpoint.child(identifier)
        } else {
            newEndpoint = newEndpoint.childByAutoId()
            self.identifier = newEndpoint.key
        }
        newEndpoint.updateChildValues(dictionaryCopy)
    }
    
    func delete() {
        guard let identifier = identifier else { return }
        FirebaseController.ref.child(endpoint).child(identifier).removeValue()
    }
}