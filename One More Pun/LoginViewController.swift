//
//  LoginViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/13/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let colorCollection = ColorCollection()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = colorCollection.randomColor()
    }
}
