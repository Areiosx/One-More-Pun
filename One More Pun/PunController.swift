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
    
    static let shared = PunController()
    
    let punsPathString = "puns"
    let reportedCountKey = "reportedCount"
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
            recentPuns.removeFirst()
            return newPun
        }
    }
    
    func getRandomPun() -> Pun {
        let newPun = punsArray[Int(arc4random_uniform(UInt32(punsArray.count)))]
        guard let id = newPun.identifier else { return newPun }
        if recentPuns.contains(id) {
            getRandomPun()
        }
        return newPun
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
    
    func getPunTextAndSubmitter(pun: Pun) -> String {
        if let submitter = pun.submitter {
            return "\(pun.body)\nSubmitted by \(submitter)"
        } else {
            return pun.body
        }
    }
    
    func getItemsToShare(pun: Pun, color: UIColor) -> [AnyObject] {
        let point = CGPointMake(10, 10)
        let imageSize = CGSize(width: 1024, height: 1024)
        let imageWithColor = getImageWithColor(color, size: imageSize)
        let image = textToImage(getPunTextAndSubmitter(pun), inImage: imageWithColor, atPoint: point)
        let comment = "Shared via One More Pun!\nhttp://tinyurl.com/OneMorePun"
        return [image, comment]
    }
}

extension PunController {
    
    // MARK: - Image Helper
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func textToImage(drawText: NSString, inImage: UIImage, atPoint: CGPoint) -> UIImage {
        guard let font = UIFont(name: "CoolveticaRg-Regular", size: 100) else { return UIImage() }
        let textColor: UIColor = UIColor.whiteColor()
        UIGraphicsBeginImageContext(inImage.size)
        let textFontAttributes = [
            NSFontAttributeName: font,
            NSForegroundColorAttributeName: textColor,
            ]
        inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
        let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
        drawText.drawInRect(rect, withAttributes: textFontAttributes)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}