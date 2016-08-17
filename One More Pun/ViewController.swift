//
//  ViewController.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit
import MessageUI
import Firebase

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    let colorCollection = ColorCollection()
    var pun = Pun(body: "")
    
    var retrievingFromNetwork: Bool = false {
        didSet {
            UIApplication.sharedApplication().networkActivityIndicatorVisible = retrievingFromNetwork
        }
    }
    
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var submitterLabel: UILabel!
    @IBOutlet weak var punButtonColor: UIButton!
    @IBOutlet weak var infoButtonColor: UIButton!
    @IBOutlet weak var addPunButtonColor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoButtonColor.hidden = true
        addPunButtonColor.hidden = true
        
        PunController.shared.observePuns { (puns) in
            self.retrievingFromNetwork = true
            PunController.shared.punsArray = puns
            dispatch_async(dispatch_get_main_queue(), { 
                self.getNewPunAndColor()
                self.retrievingFromNetwork = false
            })
        }
        
        UserController.shared.checkUserAgainstDatabase { (success) -> Void in
            if !success {
                self.showLoginSignUpView()
            }
        }
        
        UserController.shared.getLoggedInUser { (user) in
            if user == nil {
                self.showLoginSignUpView()
            }
        }
        
        let rate = RateMyApp.sharedInstance
        rate.appID = "1008575898"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            rate.trackAppUsage()
        })
    }
    
    func showLoginSignUpView() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginTableViewController else { return }
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoSegue" {
            let vc = segue.destinationViewController as! InfoViewController
            vc.pun = pun
            vc.transferBGColor = self.view.backgroundColor!
            
        }
    }
    
    @IBAction func nextPunButton(sender: AnyObject) {
        getNewPunAndColor()
    }
    
    @IBAction func addPunButtonTapped(sender: AnyObject) {
        presentSubmitPunAlert(nil)
    }
    
    func getNewPunAndColor() {
        pun = PunController.shared.randomPun()
        setUpColor()
        punLabel.text = pun.body
        submitterLabel.text = submitterLabelText(pun)
    }
    
    func setUpColor() {
        let color = colorCollection.randomColor()
        view.backgroundColor = color
        punButtonColor.tintColor = color
        infoButtonColor.hidden = false
        infoButtonColor.tintColor = color
        addPunButtonColor.hidden = false
        addPunButtonColor.tintColor = color
    }
    
    func submitterLabelText(pun: Pun) -> String {
        if let submitter = pun.submitter {
            return "Submitted by \(submitter)"
        } else {
            return ""
        }
    }
    
    // MARK: - AlertController
    
    func presentSubmitPunAlert(storedPun: String?) {
        let alert = UIAlertController(title: "Got a pun?", message: "Submitting puns is punderful.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (punTextField) in
            punTextField.placeholder = "Enter pun here"
            punTextField.text = storedPun
            punTextField.autocorrectionType = .Yes
            punTextField.autocapitalizationType = .Sentences
            punTextField.spellCheckingType = .Yes
        }
        let submitAction = UIAlertAction(title: "Submit", style: .Default) { (_) in
            guard let textFields = alert.textFields,
                punTextField = textFields.first,
                punText = punTextField.text else { return }
            self.presentSubmitPunConfirmationAlert(punText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func presentSubmitPunConfirmationAlert(punBody: String) {
        let alert = UIAlertController(title: "All done?", message: "This is your pun:\n\(punBody)", preferredStyle: .Alert)
        let submitAction = UIAlertAction(title: "Looks good!", style: .Default) { (_) in
            PunController.shared.createPun(punBody)
        }
        let reEnterAction = UIAlertAction(title: "Re-enter", style: .Cancel) { (_) in
            self.presentSubmitPunAlert(punBody)
        }
        alert.addAction(submitAction)
        alert.addAction(reEnterAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

