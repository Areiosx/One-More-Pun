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
import StoreKit

class PunViewController: UIViewController, MFMailComposeViewControllerDelegate, PunControllerDelegate {
    
    let userController = UserController()
    let punController = PunController()
    let colorCollection = ColorCollection()
    var pun = Pun(body: "") {
        didSet {
            upvoteLabel.text = "\(pun.upvoteCount)"
            downvoteLabel.text = "\(pun.downvoteCount)"
        }
    }
    var color = UIColor()
    var punsSeenCount = 0 {
        didSet {
            if punsSeenCount == 5 {
                requestReview()
            }
        }
    }

    var retrievingFromNetwork: Bool = false {
        didSet {
            UIApplication.shared.isNetworkActivityIndicatorVisible = retrievingFromNetwork
        }
    }
    
    func printFonts() {
        for familyName in UIFont.familyNames {
            print("\n-- \(familyName) \n")
            for fontName in UIFont.fontNames(forFamilyName: familyName) {
                print(fontName)
            }
        }
    }
    
    @IBOutlet weak var punLabel: UILabel!
    @IBOutlet weak var submitterLabel: UILabel!
    @IBOutlet weak var punButtonColor: UIButton!
    @IBOutlet weak var infoButtonColor: UIButton!
    @IBOutlet weak var upvoteImage: UIImageView!
    @IBOutlet weak var upvoteLabel: UILabel!
    @IBOutlet weak var downvoteImage: UIImageView!
    @IBOutlet weak var downvoteLabel: UILabel!
    @IBOutlet weak var upvoteButton: UIButton!
    @IBOutlet weak var downvoteButton: UIButton!
    @IBOutlet weak var randomizeSwitch: UISwitch!
    @IBOutlet weak var randomizeNotificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        punController.delegate = self
        randomizeSwitch.isOn = UserDefaults.standard.bool(forKey: .randomOrTopKey)
        randomizeNotificationLabel.text = .randomModeOnKey
        //        printFonts()
        hideViews()
        userController.getLoggedInUser { (user) in
            if user == nil {
                self.showLoginSignUpView()
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !UserDefaults.standard.bool(forKey: .sawRandomInfoPopupKey) {
            presentRandomOrTopAlert()
        } else {
            checkUserAndReloadData()
        }
    }
    
    func requestReview() {
        if UserDefaults.standard.integer(forKey: .launchCountKey) >= 3,
            #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
    }
    
    func hideViews() {
        infoButtonColor.isHidden = true
        punButtonColor.isHidden = true
        submitterLabel.isHidden = true
        upvoteButton.isHidden = true
        upvoteImage.isHidden = true
        upvoteLabel.isHidden = true
        downvoteButton.isHidden = true
        downvoteImage.isHidden = true
        downvoteLabel.isHidden = true
        randomizeSwitch.isHidden = true
        randomizeNotificationLabel.isHidden = true
    }
    
    func showViews() {
        UIView.animate(withDuration: 0.25) {
            self.infoButtonColor.isHidden = false
            self.punButtonColor.isHidden = false
            self.submitterLabel.isHidden = false
            self.upvoteButton.isHidden = false
            self.upvoteImage.isHidden = false
            self.upvoteLabel.isHidden = false
            self.downvoteButton.isHidden = false
            self.downvoteImage.isHidden = false
            self.downvoteLabel.isHidden = false
            self.randomizeSwitch.isHidden = false
            self.randomizeNotificationLabel.isHidden = false
        }
    }
    
    func disableVotingButtons() {
        upvoteButton.isEnabled = false
        downvoteButton.isEnabled = false
    }
    
    func reenableVotingButtons() {
        upvoteButton.isEnabled = true
        downvoteButton.isEnabled = true
    }
    
    
    
    @IBAction func upvoteButtonTapped(_ sender: Any) {
        checkIfCurrentUserIsNil({
            disableVotingButtons()
            punController.upvote(pun: pun) {
                DispatchQueue.main.async {
                    self.reenableVotingButtons()
                    self.updateVoteCountLabels()
                }
            }
        }) {
            presentNoAccountAlert()
        }
    }
    
    @IBAction func downvoteButtonTapped(_ sender: Any) {
        checkIfCurrentUserIsNil({
            disableVotingButtons()
            punController.downvote(pun: pun) {
                DispatchQueue.main.async {
                    self.reenableVotingButtons()
                    self.updateVoteCountLabels()
                }
            }
        }) {
            presentNoAccountAlert()
        }
    }
    
    @IBAction func randomizeSwitchToggled(_ sender: UISwitch) {
        randomizeNotificationLabel.text = sender.isOn ? .randomModeOnKey : .randomModeOffKey
        UserDefaults.standard.set(sender.isOn, forKey: .randomOrTopKey)
    }
    
    // MARK: - Pun Info Options
    
    @IBAction func infoButtonTapped(_ sender: AnyObject) {
        showPunInfoActionSheet()
    }
    
    func checkUserAndReloadData() {
        checkIfCurrentUserIsNil({
            userController.checkUserAgainstDatabase { (success, error) -> Void in
                if success {
                    self.fetchAndObservePuns()
                } else {
                    guard let error = error else { return }
                    self.presentErrorAlert(error.localizedDescription, completion: {
                        self.showLoginSignUpView()
                    })
                }
            }
        }) {
            fetchAndObservePuns()
        }
    }
    
    func fetchAndObservePuns() {
        self.retrievingFromNetwork = true
        punController.fetchPuns {
            self.getNewPunAndColor()
        }
        punController.observePuns {
            self.retrievingFromNetwork = false
        }
    }
    
    func updateVoteCountLabels() {
        upvoteLabel.text = "\(pun.upvoteCount)"
        downvoteLabel.text = "\(pun.downvoteCount)"
    }
    
    func showLoginSignUpView() {
        let storyboard = UIStoryboard(name: .mainStoryboardNameKey, bundle: nil)
        guard let vc = storyboard.instantiateViewController(withIdentifier: .loginViewControllerIDKey) as? LoginTableViewController else { return }
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func nextPunButton(_ sender: AnyObject) {
        getNewPunAndColor()
        punsSeenCount += 1
    }
    
    func getNewPunAndColor() {
        pun = !UserDefaults.standard.bool(forKey: .randomOrTopKey) ? punController.getNextPun() : punController.getRandomPun()
        setUpColor()
        punLabel.text = pun.body
        submitterLabel.text = submitterLabelText(pun)
        reenableVotingButtons()
    }
    
    func setUpColor() {
        color = colorCollection.randomColor()
        view.backgroundColor = color
        punButtonColor.tintColor = color
        randomizeSwitch.tintColor = color
        randomizeSwitch.onTintColor = color
        infoButtonColor.tintColor = color
    }
    
    func submitterLabelText(_ pun: Pun) -> String {
        return pun.submitter != nil ? "Submitted by \(pun.submitter!)" : ""
    }
    
    func checkIfCurrentUserIsNil(_ ifNotNil: () -> Void, ifNil: () -> Void) {
        if FIRAuth.auth()?.currentUser != nil {
            ifNotNil()
        } else {
            ifNil()
        }
    }
    
    // MARK: - Pun controller delegate
    
    func punsUpdated() {
        showViews()
        reenableVotingButtons()
        if punsSeenCount == 0 {
            getNewPunAndColor()
        }
    }
    
    // MARK: - AlertController
    
    func presentSubmitPunAlert(_ storedPun: String?) {
        let alert = UIAlertController(title: "Got a pun?", message: "Submitting puns is punderful.", preferredStyle: .alert)
        alert.addTextField { (punTextField) in
            punTextField.placeholder = "Enter pun here"
            punTextField.text = storedPun
            punTextField.autocorrectionType = .yes
            punTextField.autocapitalizationType = .sentences
            punTextField.spellCheckingType = .yes
        }
        let submitAction = UIAlertAction(title: "Submit", style: .default) { (_) in
            guard let textFields = alert.textFields,
                let punTextField = textFields.first,
                let punText = punTextField.text, !punText.isEmpty else { return }
            self.presentSubmitPunConfirmationAlert(punText)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentSubmitPunConfirmationAlert(_ punBody: String) {
        let alert = UIAlertController(title: "All done?", message: "Be sure to check spelling and grammar! Here's how it looks:\n\(punBody)", preferredStyle: .alert)
        let submitAction = UIAlertAction(title: "Looks good!", style: .default) { (_) in
            self.punController.createPun(punBody)
        }
        let reEnterAction = UIAlertAction(title: "Re-enter", style: .destructive) { (_) in
            self.presentSubmitPunAlert(punBody)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(submitAction)
        alert.addAction(reEnterAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentErrorAlert(_ error: String, completion: (() -> Void)?) {
        let alert = UIAlertController(title: "Error!", message: error, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (_) in
            if let completion = completion {
                completion()
            }
        }
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showPunInfoActionSheet() {
        let actionSheet = UIAlertController(title: "", message: "Options", preferredStyle: .actionSheet)
        let submitPunAction = UIAlertAction(title: "Submit A Pun", style: .default) { (_) in
            self.checkIfCurrentUserIsNil({
                self.presentSubmitPunAlert(nil)
            }, ifNil: {
                self.presentNoAccountAlert()
            })
        }
        let shareAction = UIAlertAction(title: "Share Pun", style: .default) { (_) in
            self.share()
        }
        let googleAction = UIAlertAction(title: "Don't get it?", style: .default) { (_) in
            self.openGoogleForPun()
        }
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            self.checkIfCurrentUserIsNil({
                self.presentReportPunAlert()
            }, ifNil: {
                self.presentNoAccountAlert()
            })
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        actionSheet.addAction(submitPunAction)
        actionSheet.addAction(shareAction)
        actionSheet.addAction(googleAction)
        actionSheet.addAction(reportAction)
        actionSheet.addAction(cancelAction)
        actionSheet.popoverPresentationController?.sourceView = infoButtonColor
        present(actionSheet, animated: true, completion: nil)
    }
    
    func share() {
        let items = punController.getItemsToShare(pun, color: color)
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.excludedActivityTypes = [UIActivityType.copyToPasteboard, UIActivityType.airDrop, UIActivityType.addToReadingList, UIActivityType.assignToContact, UIActivityType.postToTencentWeibo, UIActivityType.postToVimeo, UIActivityType.print, UIActivityType.postToWeibo]
        present(activityViewController, animated: true, completion: nil)
    }
    
    func openGoogleForPun() {
        let replaced = pun.body.replacingOccurrences(of: " ", with: "+")
        if let url = URL(string: "http://lmgtfy.com/?q=\(replaced)") {
            UIApplication.shared.openURL(url)
        }
    }
    
    func presentReportPunAlert() {
        let alert = UIAlertController(title: "Report pun?", message: "Only use this feature if you want to report this pun as inappropriate or not a real pun.", preferredStyle: .alert)
        let reportAction = UIAlertAction(title: "Report", style: .destructive) { (_) in
            self.punController.report(pun: self.pun)
            self.presentPunReportedConfirmation()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(reportAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentPunReportedConfirmation() {
        let alert = UIAlertController(title: "Pun Reported", message: "Your complaint has been recorded. Thank you for keeping One More Pun awesome!", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(okayAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentNoAccountAlert() {
        let alert = UIAlertController(title: "Oops!", message: "Looks like you don't have an account. Please sign up or log in to use this feature.", preferredStyle: .alert)
        let signupLoginAction = UIAlertAction(title: "Sign up or login", style: .default) { (_) in
            self.showLoginSignUpView()
        }
        let cancelAction = UIAlertAction(title: "Never mind", style: .cancel, handler: nil)
        alert.addAction(signupLoginAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func presentRandomOrTopAlert() {
        let alertController = UIAlertController(title: "How would you like to see puns?", message: nil, preferredStyle: .alert)
        let randomAction = UIAlertAction(title: "Randomized!", style: .default) { (_) in
            self.randomizeSwitch.isOn = true
            UserDefaults.standard.set(true, forKey: .randomOrTopKey)
            self.presentChangePunsAlert(withSelection: "randomized!")
        }
        let topAction = UIAlertAction(title: "Top First!", style: .default) { (_) in
            self.randomizeSwitch.isOn = false
            UserDefaults.standard.set(false, forKey: .randomOrTopKey)
            self.presentChangePunsAlert(withSelection: "top first!")
        }
        alertController.addAction(randomAction)
        alertController.addAction(topAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentChangePunsAlert(withSelection selection: String) {
        let alertController = UIAlertController(title: "Puns set to \(selection)", message: "You can change this later with the switch in the bottom-right corner.", preferredStyle: .alert)
        let dismissAction = UIAlertAction(title: "Okay!", style: .default) { (_) in
            UserDefaults.standard.set(true, forKey: .sawRandomInfoPopupKey)
            self.checkUserAndReloadData()
        }
        alertController.addAction(dismissAction)
        present(alertController, animated: true, completion: nil)
        randomizeSwitch.isHidden = false
    }
}
