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

class InfoViewController: UIViewController, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var punString = ""
    var transferBGColor = UIColor()
    let colorCollection = ColorCollection()
    
    @IBOutlet weak var doneButtonColor: UIButton!
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var feedbackButtonColor: UIButton!
    @IBOutlet weak var googleButtonColor: UIButton!
    @IBOutlet weak var facebookButtonColor: UIButton!
    @IBOutlet weak var twitterButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punLabel.text = punString
        view.backgroundColor = transferBGColor
        doneButtonColor.tintColor = transferBGColor
        setButtonAttributes([feedbackButtonColor, googleButtonColor, facebookButtonColor, twitterButtonColor, textButtonColor, doneButtonColor])
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
        shareToFacebook.addImage(textToImage(punString, inImage: getImageWithColor (randomBGColor, size: imageSize), atPoint: point))
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
        shareToTwitter.addImage(textToImage(punString, inImage: getImageWithColor (randomBGColor, size: imageSize), atPoint: point))
        shareToTwitter.setInitialText("Shared via One More Pun!")
        shareToTwitter.addURL(NSURL(string: "http://tinyurl.com/OneMorePun"))
    }
    
    @IBAction func textButton(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        messageVC.body = "\(punString)"
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
        let replaced = punString.stringByReplacingOccurrencesOfString(" ", withString: "+")
        if let url = NSURL(string: "http://lmgtfy.com/?q=\(replaced)") {
            UIApplication.sharedApplication().openURL(url)
        }
        print(replaced)
    }
    
    @IBAction func feedbackButton(sender: AnyObject) {
        let emailTitle = "Feedback"
        let messageBody = "Submit a pun or bug report?"
        let toRecipients = ["OneMorePun@gmail.com"]
        let mc: MFMailComposeViewController = MFMailComposeViewController()
        mc.mailComposeDelegate = self
        mc.setSubject(emailTitle)
        mc.setMessageBody(messageBody, isHTML: false)
        mc.setToRecipients(toRecipients)
        
        self.presentViewController(mc, animated: true, completion: nil)
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
    
    // MARK: - AlertController
    
    func presentSubmitPunAlert() {
        let alert = UIAlertController(title: "Submit a pun?", message: "Enter a pun to submit!", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (punTextField) in
            punTextField.placeholder = "Enter pun here"
        }
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            guard let textFields = alert.textFields,
                punTextField = textFields.first,
                punText = punTextField.text else { return }
            PunController.createPun(punText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}