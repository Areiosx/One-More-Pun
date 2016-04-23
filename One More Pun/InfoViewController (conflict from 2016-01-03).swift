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
    let colorCollection = ColorCollection()
    
    @IBOutlet weak var doneButtonColor: UIBarButtonItem!
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var feedbackButtonColor: UIButton!
    @IBOutlet weak var googleButtonColor: UIButton!
    @IBOutlet weak var facebookButtonColor: UIButton!
    @IBOutlet weak var twitterButtonColor: UIButton!
    @IBOutlet weak var textButtonColor: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        var randomColor = colorCollection.randomColor()
        view.backgroundColor = randomColor
        doneButtonColor.tintColor = randomColor
        feedbackButtonColor.tintColor = randomColor
        googleButtonColor.tintColor = randomColor
        facebookButtonColor.tintColor = randomColor
        twitterButtonColor.tintColor = randomColor
        textButtonColor.tintColor = randomColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        
        func textToImage(drawText: NSString, inImage: UIImage, atPoint: 
        
    }
    
    @IBAction func twitterButton(sender: AnyObject) {
    }
    
    @IBAction func textButton(sender: AnyObject) {
    }
    
    @IBAction func googleButton(sender: AnyObject) {
    }
    
    @IBAction func feedbackButton(sender: AnyObject) {
    }
    
}
