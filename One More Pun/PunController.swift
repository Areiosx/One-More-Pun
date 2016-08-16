//
//  PunController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase

struct PunController {
    
    static let punsPathString = "puns"
    
    static func createPun(body: String) {
        let punIdentifier = FirebaseController.ref.child(PunController.punsPathString).childByAutoId().key
        var pun = Pun(body: body, identifier: punIdentifier)
        pun.save()
    }
    
    static func observePuns(completion: (puns: [Pun]) -> Void) {
        let punsRef = FirebaseController.ref.child(PunController.punsPathString)
        punsRef.observeEventType(.Value, withBlock: { (data) in
            guard let punsDict = data.value as? [String: [String: AnyObject]] else { completion(puns: []); return }
            let puns = punsDict.flatMap { Pun(dictionary: $1, identifier: $0) }
            completion(puns: puns)
        })
    }
}