//
//  InfoViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit
import MessageUI
import Social
import Firebase

class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    // TODO: - Carry pun object over and add reporting
    var pun = Pun(body: "")
    var transferBGColor = UIColor()
    let colorCollection = ColorCollection()
    
    @IBOutlet weak var doneButtonColor: UIButton!
    @IBOutlet weak var punLabel: UILabel!    
    @IBOutlet weak var reportButtonColor: UIButton!
    @IBOutlet weak var googleButtonColor: UIButton!
    @IBOutlet weak var facebookButtonColor: UIButton!
    @IBOutlet weak var twitterButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punLabel.text = PunController.getPunTextAndSubmitter(pun)
        view.backgroundColor = transferBGColor
        doneButtonColor.tintColor = transferBGColor
        setButtonAttributes([reportButtonColor, googleButtonColor, facebookButtonColor, twitterButtonColor, textButtonColor, doneButtonColor])
    }
    
    @IBAction func facebookButton(sender: AnyObject) {
        let bluish = UIImage(named: "bluish.jpg")
        let point = CGPoint.zero
        let imageSize = CGSize(width: 1024, height: 1024)
        var randomBGColor = colorCollection.randomColor()
        
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
            let textColor: UIColor = UIColor.whiteColor()
            let textFont: UIFont = UIFont(name: "coolvetica rg", size: 100)!
            UIGraphicsBeginImageContext(inImage.size)
            let textFontAttributes = [
                NSFontAttributeName: textFont,
                NSForegroundColorAttributeName: textColor,
                ]
            inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
            let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
            drawText.drawInRect(rect, withAttributes: textFontAttributes)
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        
        let shareToFacebook: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        self.presentViewController(shareToFacebook, animated: true, completion: nil)
        let punText = PunController.getPunTextAndSubmitter(pun)
        shareToFacebook.addImage(textToImage(punText, inImage: getImageWithColor (randomBGColor, size: imageSize), atPoint: point))
        shareToFacebook.setInitialText("Shared via One More Pun!")
        shareToFacebook.addURL(NSURL(string: "http://tinyurl.com/OneMorePun"))
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        let bluish = UIImage(named: "bluish.jpg")
        let point = CGPoint.zero
        let imageSize = CGSize(width: 1024, height: 1024)
        var randomBGColor = colorCollection.randomColor()
        
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
            let textColor: UIColor = UIColor.whiteColor()
            let textFont: UIFont = UIFont(name: "coolvetica rg", size: 100)!
            UIGraphicsBeginImageContext(inImage.size)
            let textFontAttributes = [
                NSFontAttributeName: textFont,
                NSForegroundColorAttributeName: textColor,
                ]
            inImage.drawInRect(CGRectMake(0, 0, inImage.size.width, inImage.size.height))
            let rect: CGRect = CGRectMake(atPoint.x, atPoint.y, inImage.size.width, inImage.size.height)
            drawText.drawInRect(rect, withAttributes: textFontAttributes)
            let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return newImage
        }
        
        let shareToTwitter: SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
        self.presentViewController(shareToTwitter, animated: true, completion: nil)
        shareToTwitter.addImage(textToImage("\(pun.body)\nSubmitted by \(pun.submitter)", inImage: getImageWithColor (randomBGColor, size: imageSize), atPoint: point))
        shareToTwitter.setInitialText("Shared via One More Pun!")
        shareToTwitter.addURL(NSURL(string: "http://tinyurl.com/OneMorePun"))
    }
    
    @IBAction func textButton(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "\(pun)"
        messageVC.recipients = []
        messageVC.messageComposeDelegate = self
        self.presentViewController(messageVC, animated: true, completion: nil)
    }
    
    func messageComposeViewController(controller: MFMessageComposeViewController, didFinishWithResult result: MessageComposeResult) {
        switch (result.rawValue) {
        case MessageComposeResultCancelled.rawValue:
            print("Message was cancelled.")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultFailed.rawValue:
            print("Message failed to send.")
            self.dismissViewControllerAnimated(true, completion: nil)
        case MessageComposeResultSent.rawValue:
            print("Message sent.")
            self.dismissViewControllerAnimated(true, completion: nil)
        default:
            break
        }
    }
    
    @IBAction func googleButton(sender: AnyObject) {
        let replaced = pun.body.stringByReplacingOccurrencesOfString(" ", withString: "+")
        if let url = NSURL(string: "http://lmgtfy.com/?q=\(replaced)") {
            UIApplication.sharedApplication().openURL(url)
        }
        print(replaced)
    }
    
    @IBAction func reportButtonTapped(sender: AnyObject) {
        presentReportPunAlert()
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func doneButtonPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setButtonAttributes(buttons: [UIButton]) {
        for button in buttons {
            button.tintColor = transferBGColor
            button.layer.cornerRadius = 11
            button.clipsToBounds = true
            button.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // MARK: - UIAlertController
    
    func presentReportPunAlert() {
        let alert = UIAlertController(title: "Report pun?", message: "Only use this feature if you want to report this pun as inappropriate.", preferredStyle: .Alert)
        let reportAction = UIAlertAction(title: "Report", style: .Destructive) { (_) in
            PunController.reportPun(self.pun, completion: {
                self.reportButtonColor.hidden = true
                self.presentPunReportedConfirmation()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentPunReportedConfirmation() {
        let alert = UIAlertController(title: "Pun Reported", message: "Your complaint has been recorded. Thank you for keeping One More Pun awesome!", preferredStyle: .Alert)
        let okayAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        alert.addAction(okayAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}