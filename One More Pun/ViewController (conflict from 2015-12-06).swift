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

    override func viewDidLoad() {
        super.viewDidLoad()
        var randomColor = colorCollection.randomColor()
        view.backgroundColor = randomColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

