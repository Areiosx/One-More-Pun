//
//  UserController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase

struct UserController {
    
    static let shared = UserController()
    
    private let usersPathString = "users"
    
    func createUser(email: String, password: String, name: String, completion: (user: FIRUser?, error: NSError?) -> Void) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChangesWithCompletion({ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    completion(user: user, error: error)
                    if let email = user.email,
                        username = user.displayName {
                        let userIdentifier = FirebaseController.ref.child(self.usersPathString).child(user.uid).key
                        var dbUser = User(email: email, username: username, identifier: userIdentifier)
                        dbUser.save()
                    }
                })
            } else {
                completion(user: nil, error: error)
            }
            
        })
    }
    
    func checkUserAgainstDatabase(completion: (success: Bool) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        FirebaseController.ref.child(usersPathString).observeSingleEventOfType(.Value, withBlock: { (data) in
            let uid = data.childSnapshotForPath(currentUser.uid)
            if uid.exists() {
                completion(success: true)
            } else {
                completion(success: false)
            }
        })
    }
    
    func getLoggedInUser(completion: (user: FIRUser?) -> Void) {
        FIRAuth.auth()?.addAuthStateDidChangeListener { (auth, user) in
            if let user = user {
                completion(user: user)
            } else {
                completion(user: nil)
            }
        }
    }
    
    func signInUser(email: String, password: String, completion: (user: FIRUser?, error: NSError?) -> Void) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            completion(user: user, error: error)
        })
    }
}