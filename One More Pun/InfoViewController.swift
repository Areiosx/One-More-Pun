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

class InfoViewController: UIViewController, MFMessageComposeViewControllerDelegate {

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
    
    func setButtonAttributes(buttons: [UIButton]) {
        for button in buttons {
            button.tintColor = transferBGColor
            button.layer.cornerRadius = 11
            button.clipsToBounds = true
            button.backgroundColor = UIColor.whiteColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punLabel.text = PunController.getPunTextAndSubmitter(pun)
        view.backgroundColor = transferBGColor
        doneButtonColor.tintColor = transferBGColor
        setButtonAttributes([reportButtonColor, googleButtonColor, facebookButtonColor, twitterButtonColor, textButtonColor, doneButtonColor])
    }
    
    // MARK: - Sharing Functions
    
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
    
    func shareToSocialMedia(serviceType: String) {
        let point = CGPointZero
        let imageSize = CGSize(width: 1024, height: 1024)
        let color = transferBGColor
        let url = NSURL(string: "http://tinyurl.com/OneMorePun")
        
        let share = SLComposeViewController(forServiceType: serviceType)
        presentViewController(share, animated: true, completion: nil)
        let punText = PunController.getPunTextAndSubmitter(pun)
        share.addImage(textToImage(punText, inImage: getImageWithColor(color, size: imageSize), atPoint: point))
        share.setInitialText("Shared via One More Pun!")
        share.addURL(url)
    }
    
    @IBAction func facebookButton(sender: AnyObject) {
        shareToSocialMedia(SLServiceTypeFacebook)
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
        shareToSocialMedia(SLServiceTypeTwitter)
    }
    
    @IBAction func textButton(sender: AnyObject) {
        let messageVC = MFMessageComposeViewController()
        let punText = PunController.getPunTextAndSubmitter(pun)
        messageVC.body = punText
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
    
    // MARK: - UIAlertController
    
    func presentReportPunAlert() {
        let alert = UIAlertController(title: "Report pun?", message: "Only use this feature if you want to report this pun as inappropriate or not a real pun.", preferredStyle: .Alert)
        let reportAction = UIAlertAction(title: "Report", style: .Destructive) { (_) in
            PunController.shared.reportPun(self.pun)
            self.reportButtonColor.hidden = true
            self.presentPunReportedConfirmation()
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