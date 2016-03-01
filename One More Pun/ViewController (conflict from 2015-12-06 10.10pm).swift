//
//  ViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let puns = Puns()
    let colorCollection = ColorCollection()
    
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var submitterLabel: UILabel!
    @IBOutlet weak var punButtonColor: UIButton!
    @IBOutlet weak var infoButtonColor: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var randomColor = colorCollection.randomColor()
        view.backgroundColor = randomColor
        infoButtonColor.tintColor = randomColor
        punLabel.text = puns.randomPun()
        submitterLabel.text = ""
        var rate = RateMyApp.sharedInstance
        rate.appID = "1008575898"
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            rate.trackAppUsage()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func nextPunButton(sender: AnyObject) {
    }

}

