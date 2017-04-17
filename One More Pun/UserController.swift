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
    
    func createUser(_ email: String, password: String, name: String, completion: @escaping (_ user: FIRUser?, _ error: NSError?) -> Void) {
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChanges(completion: { (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    completion(user, error as NSError?)
                    if let email = user.email,
                        let username = user.displayName {
                        let userIdentifier = FirebaseController.ref.child(.usersTypeKey).child(user.uid).key
                        var dbUser = User(email: email, username: username, identifier: userIdentifier)
                        dbUser.save()
                    }
                })
            } else {
                completion(nil, error as NSError?)
            }
        })
    }
    
    func checkUserAgainstDatabase(_ completion: @escaping (_ success: Bool, _ error: NSError?) -> Void) {
        guard let currentUser = FIRAuth.auth()?.currentUser else { return }
        currentUser.getTokenForcingRefresh(true) { (idToken, error) in
            if let error = error {
                completion(false, error as NSError?)
                print(error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    func getLoggedInUser(_ completion: @escaping (_ user: FIRUser?) -> Void) {
        FIRAuth.auth()?.addStateDidChangeListener { (auth, user) in
            if let user = user {
                completion(user)
            } else {
                completion(nil)
            }
        }
    }
    
    func signInUser(_ email: String, password: String, completion: @escaping (_ user: FIRUser?, _ error: Error?) -> Void) {
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            completion(user, error)
        })
    }
}
