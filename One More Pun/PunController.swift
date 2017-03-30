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
    
    var punsArray: [Pun] = []
    
    func randomPun() -> Pun {
        if punsArray.count == 0 {
            let noPun = Pun(body: "No puns right now. Go ahead and submit one!")
            noPun.submitter = nil
            return noPun
        } else {
            let newPun = getRandomPun()
            guard let id = newPun.identifier else { return newPun }
            recentPuns.append(id)
            if recentPuns.count >= punsArray.count {
                recentPuns.removeFirst()
            }
            return newPun
        }
    }
    
    func getRandomPun() -> Pun {
        var newPun = punsArray[Int(arc4random_uniform(UInt32(punsArray.count)))]
        guard let id = newPun.identifier else { return newPun }
        if recentPuns.contains(id) {
            newPun = getRandomPun()
        }
        return newPun
    }
    
    func createPun(_ body: String) {
        let punIdentifier = FirebaseController.ref.child(.punsTypeKey).childByAutoId().key
        var pun = Pun(body: body, identifier: punIdentifier)
        pun.save()
    }
    
    func observePuns(_ completion: @escaping (_ puns: [Pun]) -> Void) {
        let punsRef = FirebaseController.ref.child(.punsTypeKey)
        punsRef.observe(.value, with: { (data) in
            guard let punsDict = data.value as? [String: [String: AnyObject]] else { completion([]); return }
            let unfilteredPuns = punsDict.flatMap { Pun(dictionary: $1, identifier: $0) }
            let sortedPuns = unfilteredPuns.sorted(by: { $0.0.upvoteCount > $0.1.upvoteCount })
            let punsToDelete = unfilteredPuns.filter { $0.downvoteCount >= 5 && $0.downvoteCount >= $0.upvoteCount / 4 || $0.reportedCount >= 5 }
            for pun in punsToDelete {
                self.deletePun(pun)
            }
            completion(sortedPuns)
        })
    }
    
    func deletePun(_ pun: Pun) {
        guard let identifier = pun.identifier else { return }
        FirebaseController.ref.child(pun.endpoint).child(identifier).removeValue()
    }
    
    func upvote(pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
        let voteDictionary = [voterIdentifier: 1]
        let childUpdates: [String: Any] = ["/\(pun.endpoint)/\(punIdentifier)/\(String.upvoteIdentifiersDictionaryKey)": voteDictionary]
        if pun.downvoteIdentifiersArray.contains(voterIdentifier) {
            removeDownvote(forPun: pun)
        }
        FirebaseController.ref.updateChildValues(childUpdates)
    }
    
    func removeUpvote(forPun pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
        FirebaseController.ref.child(pun.endpoint).child(punIdentifier).child(.upvoteIdentifiersDictionaryKey).child(voterIdentifier).removeValue()
    }
    
    func downvote(pun: Pun, completion: @escaping () -> Void = { _ in } ) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
        let voteDictionary = [voterIdentifier: 1]
        let childUpdates: [String: Any] = ["/\(pun.endpoint)/\(punIdentifier)/\(String.downvoteIdentifiersDictionary)": voteDictionary]
        if pun.upvoteIdentifiersArray.contains(voterIdentifier) {
            removeUpvote(forPun: pun)
        }
        FirebaseController.ref.updateChildValues(childUpdates)
    }
    
    func removeDownvote(forPun pun: Pun, completion: @escaping () -> Void = { _ in }) {
        defer { completion() }
        guard let punIdentifier = pun.identifier,
            let voterIdentifier = FIRAuth.auth()?.currentUser?.uid else { return }
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
