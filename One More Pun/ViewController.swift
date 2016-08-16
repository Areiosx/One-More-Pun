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
    
    var puns = Puns()
    let colorCollection = ColorCollection()
    var user: FIRUser?
    
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var submitterLabel: UILabel!
    @IBOutlet weak var punButtonColor: UIButton!
    @IBOutlet weak var infoButtonColor: UIButton!
    @IBOutlet weak var addPunButtonColor: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PunController.observePuns { (puns) in
            self.puns.punsArray = puns
        }
        
        FirebaseController.shared.getLoggedInUser { (user) in
            self.user = user
            if self.user == nil {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                guard let vc = storyboard.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController else { return }
                self.presentViewController(vc, animated: true, completion: nil)
            }
        }
        
        getNewPunAndColor()
        
        let rate = RateMyApp.sharedInstance
        rate.appID = "1008575898"
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            rate.trackAppUsage()
        })
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "infoSegue" {
            let vc = segue.destinationViewController as! InfoViewController
            vc.punString = punLabel.text!
            vc.transferBGColor = self.view.backgroundColor!
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func nextPunButton(sender: AnyObject) {
        getNewPunAndColor()
    }
    
    @IBAction func addPunButtonTapped(sender: AnyObject) {
        presentSubmitPunAlert(nil)
    }
    
    func getNewPunAndColor() {
        let pun = puns.randomPun()
        setUpColor()
        punLabel.text = pun.body
        submitterLabel.text = submitterLabelText(pun)
    }
    
    func setUpColor() {
        let color = colorCollection.randomColor()
        view.backgroundColor = color
        punButtonColor.tintColor = color
        infoButtonColor.tintColor = color
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
            PunController.createPun(punBody)
        }
        let reEnterAction = UIAlertAction(title: "Re-enter", style: .Cancel) { (_) in
            self.presentSubmitPunAlert(punBody)
        }
        alert.addAction(submitAction)
        alert.addAction(reEnterAction)
        presentViewController(alert, animated: true, completion: nil)
    }
}

