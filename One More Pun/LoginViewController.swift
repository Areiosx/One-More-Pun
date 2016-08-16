//
//  LoginViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/13/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
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
    @IBOutlet weak var retypePasswordTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    
    @IBAction func screenTapped(sender: AnyObject) {
        resignFirstResponders()
    }
    
    @IBAction func haveAccountButtonTapped(sender: AnyObject) {
        hasAccount = !hasAccount
    }
    
    @IBAction func goButtonTapped(sender: AnyObject) {
        if !hasAccount && passwordTextField.text == retypePasswordTextField.text {
            guard let email = emailTextField.text,
                password = passwordTextField.text,
                name = nameTextField.text else { return }
            UserController.shared.createUser(email, password: password, name: name, completion: { (_, error) in
                if error != nil {
                    self.showErrorInFormAlert()
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
            })
        } else if !hasAccount {
            showMismatchedPasswordsAlert()
        } else {
            guard let email = emailTextField.text,
                password = passwordTextField.text else { return }
            UserController.shared.signInUser(email, password: password, completion: { (_, error) in
                if error != nil {
                    self.showErrorInFormAlert()
                } else {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            retypePasswordTextField.becomeFirstResponder()
        case retypePasswordTextField:
            retypePasswordTextField.resignFirstResponder()
        default:
            break
        }
        return true
    }
    
    func resignFirstResponders() {
        nameTextField.resignFirstResponder()
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        retypePasswordTextField.resignFirstResponder()
    }
    
    func userHasAccount() {
        if hasAccount {
            signInLabel.text = "Log in"
            haveAccountButton.setTitle("Don't have an account?", forState: .Normal)
            nameTextField.hidden = true
            retypePasswordTextField.hidden = true
        } else {
            signInLabel.text = "Sign up"
            haveAccountButton.setTitle("Already have an account?", forState: .Normal)
            nameTextField.hidden = false
            passwordTextField.returnKeyType = .Next
            retypePasswordTextField.hidden = false
        }
    }
    
    func clearForm() {
        nameTextField.text = nil
        emailTextField.text = nil
        passwordTextField.text = nil
        retypePasswordTextField.text = nil
    }
    
    func setButtonAttributes(buttons: [UIButton]) {
        for button in buttons {
            button.tintColor = backgroundColor
            button.layer.cornerRadius = 11
            button.clipsToBounds = true
            button.backgroundColor = UIColor.whiteColor()
        }
    }
    
    // MARK: - AlertController
    
    func showMismatchedPasswordsAlert() {
        let alert = UIAlertController(title: "Passwords Don't Match", message: "Please make sure the password is the same in both fields.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            self.passwordTextField.text = nil
            self.retypePasswordTextField.text = nil
            self.passwordTextField.becomeFirstResponder()
        }
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showErrorInFormAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Something's not right. Check your information and try again.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (_) in
            self.clearForm()
        }
        alert.addAction(okAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}
