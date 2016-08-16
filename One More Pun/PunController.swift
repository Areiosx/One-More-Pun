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
    static let reportedCountKey = "reportedCount"
    
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
    
    static func reportPun(pun: Pun, completion: () -> Void) {
        guard let identifier = pun.identifier,
            currentUser = FIRAuth.auth()?.currentUser else { return }
        let reports = "\(pun.reportedCount + 1)"
        let childUpdates: [NSObject: AnyObject] = ["/\(pun.endpoint)/\(identifier)/\(PunController.reportedCountKey)": reports,
                            "/\(pun.endpoint)/\(identifier)/\(PunController.reportedCountKey)/\(reports)": currentUser.uid]
        FirebaseController.ref.updateChildValues(childUpdates)
    }
    
    static func getPunTextAndSubmitter(pun: Pun) -> String {
        if let submitter = pun.submitter {
            return "\(pun.body)\nSubmitted by \(submitter)"
        } else {
            return pun.body
        }
    }
}