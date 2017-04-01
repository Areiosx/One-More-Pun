//
//  PunController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/14/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import Foundation
import Firebase
import UIKit

class PunController {
    
    var recentPuns = [String]()
    var delegate: PunControllerDelegate?
    var puns = [Pun]() {
        didSet {
            NSLog("Puns updated")
            delegate?.punsUpdated()
        }
    }
    var punIndex = 0
    
    func getNextPun() -> Pun {
        if puns.count == 0 {
            let noPun = Pun(body: "Loading...")
            noPun.submitter = nil
            return noPun
        } else if punIndex >= puns.count {
            punIndex = 0
            return puns[punIndex]
        } else {
            let pun = puns[punIndex]
            punIndex += 1
            return pun
        }
    }
    
    func getRandomPun() -> Pun {
        return puns[Int(arc4random_uniform(UInt32(puns.count)))]
    }
    
    
    func createPun(_ body: String) {
        let punIdentifier = FirebaseController.ref.child(.punsTypeKey).childByAutoId().key
        var pun = Pun(body: body, identifier: punIdentifier)
        pun.save()
    }
    
    func fetchPuns(_ completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        let punsRef = FirebaseController.ref.child(.punsTypeKey)
        punsRef.observeSingleEvent(of: .value, with: { (data) in
            guard let punsDict = data.value as? [String: [String: AnyObject]] else { return }
            let unfilteredPuns = punsDict.flatMap { Pun(dictionary: $1, identifier: $0) }
            let sortedPuns = unfilteredPuns.sorted(by: { $0.0.upvoteCount > $0.1.upvoteCount })
            var punsToDelete = unfilteredPuns.filter { $0.downvoteCount >= 5 && $0.downvoteCount >= $0.upvoteCount / 4 || $0.reportedCount >= 5 }
            punsToDelete.deleteFromFirebase()
            self.puns = sortedPuns
        })
    }
    
    func observePuns(_ completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        let punsRef = FirebaseController.ref.child(.punsTypeKey)
        punsRef.observe(.childAdded, with: { (data) in
            guard let punsDict = data.value as? [String: [String: AnyObject]] else { return }
            let puns = punsDict.flatMap { Pun(dictionary: $1, identifier: $0) }
            for pun in puns {
                if !self.puns.contains(pun) {
                    self.puns.append(pun)
                    NSLog("Added \(pun.identifier ?? "a pun") to puns")
                }
            }
        })
    }
    
    func deletePun(_ pun: Pun) {
        guard let identifier = pun.identifier else { return }
        FirebaseController.ref.child(pun.endpoint).child(identifier).removeValue()
    }
    
    func upvote(pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid,
            !pun.upvoteIdentifiersArray.contains(voterIdentifier) else { return }
        NSLog("Upvote for \(punIdentifier)")
        pun.upvoteIdentifiersArray.append(voterIdentifier)
        let endpoint = "/\(pun.endpoint)/\(punIdentifier)/\(String.upvoteIdentifiersDictionaryKey)"
        if pun.downvoteIdentifiersArray.contains(voterIdentifier) {
            removeDownvote(forPun: pun)
        }
        FirebaseController.ref.child(endpoint).child(voterIdentifier).setValue(1)
    }
    
    func removeUpvote(forPun pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
        pun.upvoteIdentifiersArray.remove(voterIdentifier)
        FirebaseController.ref.child(pun.endpoint).child(punIdentifier).child(.upvoteIdentifiersDictionaryKey).child(voterIdentifier).removeValue()
    }
    
    func downvote(pun: Pun, completion: @escaping () -> Void = { _ in } ) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid,
            !pun.downvoteIdentifiersArray.contains(voterIdentifier) else { return }
        pun.downvoteIdentifiersArray.append(voterIdentifier)
        NSLog("Downvote for \(punIdentifier)")
        let endpoint = "/\(pun.endpoint)/\(punIdentifier)/\(String.downvoteIdentifiersDictionary)"
        if pun.upvoteIdentifiersArray.contains(voterIdentifier) {
            removeUpvote(forPun: pun)
        }
        FirebaseController.ref.child(endpoint).child(voterIdentifier).setValue(1)
    }
    
    func removeDownvote(forPun pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
        pun.downvoteIdentifiersArray.remove(voterIdentifier)
        FirebaseController.ref.child(pun.endpoint).child(punIdentifier).child(.downvoteIdentifiersDictionary).child(voterIdentifier).removeValue()
    }
    
    func report(pun: Pun) {
        guard let identifier = pun.identifier else { return }
        let reports = (pun.reportedCount + 1)
        let childUpdates: [AnyHashable: Any] = ["/\(pun.endpoint)/\(identifier)/\(String.reportedCountKey)": reports]
        FirebaseController.ref.updateChildValues(childUpdates)
    }
    
    func getPunTextAndSubmitter(_ pun: Pun) -> String {
        if let submitter = pun.submitter {
            return "\(pun.body)\nSubmitted by \(submitter)"
        } else {
            return pun.body
        }
    }
    
    func getItemsToShare(_ pun: Pun, color: UIColor) -> [AnyObject] {
        let point = CGPoint(x: 10, y: 10)
        let imageSize = CGSize(width: 1024, height: 1024)
        let imageWithColor = UIImage.getImageWithColor(color, size: imageSize)
        let image = UIImage.textToImage(getPunTextAndSubmitter(pun) as NSString, inImage: imageWithColor, atPoint: point)
        let comment = "Shared via One More Pun!\nhttp://tinyurl.com/OneMorePun"
        return [image, comment as AnyObject]
    }
}

protocol PunControllerDelegate {
    func punsUpdated()
}
