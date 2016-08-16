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
    
    func createUser(email: String, password: String, name: String, completion: (user: FIRUser) -> Void) {
        FIRAuth.auth()?.createUserWithEmail(email, password: password, completion: { (user, error) in
            if let user = user {
                let changeRequest = user.profileChangeRequest()
                changeRequest.displayName = name
                changeRequest.commitChangesWithCompletion({ (error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    completion(user: user)
                })
            }
        })
    }
    
    func signInUser(email: String, password: String, completion: (user: FIRUser) -> Void) {
        FIRAuth.auth()?.signInWithEmail(email, password: password, completion: { (user, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let user = user {
                completion(user: user)
            }
        })
    }
}