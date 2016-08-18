//
//  PunController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase

class PunController {
    
    static let shared = PunController()
    
    let punsPathString = "puns"
    let reportedCountKey = "reportedCount"
    
    var punsArray: [Pun] = []
    
    func randomPun() -> Pun {
        if punsArray.count == 0 {
            let noPun = Pun(body: "No puns right now. Go ahead and submit one!")
            noPun.submitter = nil
            return noPun
        } else {
            let randomNumber = Int(arc4random_uniform(UInt32(punsArray.count)))
            return punsArray[randomNumber]
        }
    }
    
    func createPun(body: String) {
        let punIdentifier = FirebaseController.ref.child(punsPathString).childByAutoId().key
        var pun = Pun(body: body, reportedCount: 0, identifier: punIdentifier)
        pun.save()
    }
    
    func observePuns(completion: (puns: [Pun]) -> Void) {
        let punsRef = FirebaseController.ref.child(punsPathString)
        punsRef.observeEventType(.Value, withBlock: { (data) in
            guard let punsDict = data.value as? [String: [String: AnyObject]] else { completion(puns: []); return }
            let unfilteredPuns = punsDict.flatMap { Pun(dictionary: $1, identifier: $0) }
            let filteredPuns = unfilteredPuns.filter { $0.reportedCount < 5 }
            let punsToDelete = unfilteredPuns.filter { $0.reportedCount >= 5 }
            for pun in punsToDelete {
                self.deletePun(pun)
            }
            completion(puns: filteredPuns)
        })
    }
    
    func deletePun(pun: Pun) {
        guard let identifier = pun.identifier else { return }
        FirebaseController.ref.child(pun.endpoint).child(identifier).removeValue()
    }
    
    func reportPun(pun: Pun) {
        guard let identifier = pun.identifier else { return }
        let reports = (pun.reportedCount + 1)
        let childUpdates: [NSObject: AnyObject] = ["/\(pun.endpoint)/\(identifier)/\(reportedCountKey)": reports]
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