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
    var backgroundColor: UIColor = .whiteColor()
    var hasAccount: Bool = true {
        didSet {
            userHasAccount()
        }
    }
    
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var haveAccountButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBAction func haveAccountButtonTapped(sender: AnyObject) {
        hasAccount = !hasAccount
    }
    
    @IBAction func goButtonTapped(sender: AnyObject) {
        if !hasAccount {
            guard let email = emailTextField.text,
                password = passwordTextField.text,
                name = nameTextField.text else { return }
            UserController.shared.createUser(email, password: password, name: name, completion: { (user) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        } else {
            guard let email = emailTextField.text,
                password = passwordTextField.text else { return }
            UserController.shared.signInUser(email, password: password, completion: { (user) in
                self.dismissViewControllerAnimated(true, completion: nil)
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundColor = colorCollection.randomColor()
        view.backgroundColor = backgroundColor
        setButtonAttributes([haveAccountButton, goButton])
        userHasAccount()
    }
    
    func userHasAccount() {
        if hasAccount {
            signInLabel.text = "Log in"
            haveAccountButton.setTitle("Don't have an account?", forState: .Normal)
            nameTextField.hidden = true
        } else {
            signInLabel.text = "Sign up"
            haveAccountButton.setTitle("Already have an account?", forState: .Normal)
            nameTextField.hidden = false
        }
    }
    
    func setButtonAttributes(buttons: [UIButton]) {
        for button in buttons {
            button.tintColor = backgroundColor
            button.layer.cornerRadius = 11
            button.clipsToBounds = true
            button.backgroundColor = UIColor.whiteColor()
        }
    }
}
