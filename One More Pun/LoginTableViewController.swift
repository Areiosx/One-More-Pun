//
//  LoginTableViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 8/16/16.
//  Copyright © 2016 Areios. All rights reserved.
//

import UIKit

class LoginTableViewController: UITableViewController, UITextFieldDelegate {
    
    let userController = UserController()
    let punController = PunController()
    let colorCollection = ColorCollection()
    var backgroundColor: UIColor = .white
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
    @IBOutlet weak var goWithoutSignupLoginButton: UIButton!
    
    @IBAction func screenTapped(_ sender: AnyObject) {
        resignFirstResponders()
    }
    
    @IBAction func haveAccountButtonTapped(_ sender: AnyObject) {
        hasAccount = !hasAccount
    }
    
    @IBAction func goButtonTapped(_ sender: AnyObject) {
        if !hasAccount && passwordTextField.text == retypePasswordTextField.text {
            guard let email = emailTextField.text,
                let password = passwordTextField.text,
                let name = nameTextField.text else { return }
            userController.createUser(email, password: password, name: name, completion: { (_, error) in
                if let error = error {
                    self.showErrorInFormAlert(error.localizedDescription)
                } else {
                    self.checkPuns({
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        } else if !hasAccount {
            showMismatchedPasswordsAlert()
        } else {
            guard let email = emailTextField.text,
                let password = passwordTextField.text else { return }
            userController.signInUser(email, password: password, completion: { (_, error) in
                if let error = error {
                    self.showErrorInFormAlert(error.localizedDescription)
                } else {
                    self.checkPuns({
                        self.dismiss(animated: true, completion: nil)
                    })
                }
            })
        }
    }
    
    @IBAction func goWithoutSignupLoginButtonTapped(_ sender: AnyObject) {
        goWithoutSignupLogin()
    }
    
    func checkPuns(_ completion: @escaping () -> Void) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundColor = colorCollection.randomColor()
        view.backgroundColor = backgroundColor
        setButtonAttributes([haveAccountButton, goButton, goWithoutSignupLoginButton])
        userHasAccount()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case nameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            if hasAccount {
                textField.resignFirstResponder()
            } else {
                retypePasswordTextField.becomeFirstResponder()
            }
        case retypePasswordTextField:
            textField.resignFirstResponder()
        default:
            resignFirstResponders()
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
            haveAccountButton.setTitle("Don't have an account?", for: UIControlState())
        } else {
            signInLabel.text = "Sign up"
            haveAccountButton.setTitle("Already have an account?", for: UIControlState())
            passwordTextField.returnKeyType = .next
        }
        nameTextField.isHidden = hasAccount
        retypePasswordTextField.isHidden = hasAccount
    }
    
    func setButtonAttributes(_ buttons: [UIButton]) {
        for button in buttons {
            button.tintColor = backgroundColor
            button.layer.cornerRadius = 11
            button.clipsToBounds = true
            button.backgroundColor = UIColor.white
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = backgroundColor
        cell.selectionStyle = .none
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destinationVC = segue.destination as? PunViewController else { return }
        destinationVC.checkUserAndReloadData()
    }
    
    
    // MARK: - AlertController
    
    func showMismatchedPasswordsAlert() {
        let alert = UIAlertController(title: "Passwords Don't Match", message: "Please make sure the password is the same in both fields.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.passwordTextField.text = nil
            self.retypePasswordTextField.text = nil
            self.passwordTextField.becomeFirstResponder()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showErrorInFormAlert(_ message: String) {
        let alert = UIAlertController(title: "Oops!", message: "Something's not right:\n\(message).", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func goWithoutSignupLogin() {
        let alert = UIAlertController(title: "Enter without signing in?", message: "You will be able to use the app to see puns but won't be able to submit or report any. You will have the choice to sign up in the future.", preferredStyle: .alert)
        let agreeAction = UIAlertAction(title: "That's fine, let's see some puns!", style: .default) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(agreeAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
