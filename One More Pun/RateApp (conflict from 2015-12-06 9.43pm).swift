//
//  RateApp.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit

class RateMyApp : UIViewController, UIAlertViewOelegate {
    
    private let kTrackingAppVersion = "kRateMyApp_TrackingAppVersion"
    private let kFirstUseDate = "kRateMyApp_FirstUseDate"
    private let kAppUseCount = "kRateMyApp_AppUseCount"
    private let kSpecialEventCount = "kRateHyApp_SpecialEventCount"
    private let kDidRateVersion = "kRateMyApp_DidRateVersion"
    private let kDeclinedToRate = "kRateMyApp_DeclinedToRate"
    private let kRemindLater = "kRateMyApp_RemindLater"
    private let kRemindLaterPressedDate = "kRateHyApp_RemindLaterPressedDate"
    private var reviewURL = "https://itunes.apple.com/us/aPP/appName/id10085758987mt=8"
    private var reviewURLiOS7 = "https://itunes.apple.com/us[app/appName/id1008575898?mt=8"
    
    let promptAfterDays: Double = 5
    let promptAfterUses = 3
    let promptAfterCustomEventsCount = 10
    let daysBeforeReminding: Double = 1
    
    let alertTitle = NSLocalizedString("Like puns?", comment: "RateMyApp")
    var alertMessage = ""
    let alertOKTitle = NSLocalizedString("5 Stars!", comment: "RateMyApp")
    let alertCancelTitle = NSLocalizedString("Never! I hate happiness!", comment: "RateMyApp")
    let alertReminderTitle = NSLocalizedString("Maybe later, let me see some puns first.", comment: "RateMyApp")
    let appID = "1008575898"
    
    class var sharedInstance: RateMyApp {
        struct Static {
            static let instance: RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    private func initAllSettings() {
        let prefs = NSUserDefaults.standardUserDefaults()
        
        prefs.setObject(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.setObject(NSDate, forKey: kFirstUseDate)
        prefs.setInteger(1, forKey: kAppUseCount)
        prefs.setInteger(0, forKey: kSpecialEventCount)
        prefs.setBool(false, forKey: kDidRateVersion)
        prefs.setBool(false, forKey: kDeclinedToRate)
        prefs.setBool(false, forKey: kRemindLater)
    }
    
    func trackEventUsage() {
        incrementValueForKey(name: kSpecialEventCount)
    }
    
    func trackAppUsage() {
        incrementValueForKey(name: kAppUseCount)
    }
    
    private func isFirstTime() -> Bool {
        let prefs = NSUserDefaults.standardUserDefaults()
        let trackingAppVersion = prefs.objectForKey(kTrackingAppVersion) as? NSString
        if ((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqualToString(trackingAppVersion!as String))) {
            return true
        }
        return false
    }
    
    private func incrementValueForKey(#name: String) {
        if (count(appID) == 0) {
            fatalError("Set iTunes Connect appID to proceed, you may enter some random string for testing purposes. See line number 34.")
        }
        if(isFirstTime()) {
            initAllSettings()
        } else {
            var prefs  = NSUserDefaults.standardUserDefaults()
            var currentCount = prefs.integerForKey(name)
            prefs.setInteger(currentCount+1, forKey: name)
        }
        if (shouldShowAlert()) {
            showRatingAlert()
        }
    }
    
    private func shouldShowAlert() -> Bool {
        let prefs = NSUserDefaults.standardUserDefaults()
        let usageCount = prefs.integerForKey(kAppUseCount)
        let eventsCount = prefs.integerForKey(kSpecialEventCount)
        let firstUse = prefs.objectForKey(kFirstUseDate) as! NSDate
        let timeInterval = NSDate().timeIntervalSinceDate(firstUse)
        let daysCount = ((timeInterval / 3600) / 24)
        let hasRatedCurrentVersion = prefs.boolForKey(kDidRateVersion)
        let hasDeclinedToRate = prefs.boolForKey(kDeclinedToRate)
        let hasChosenRemindLater = prefs.boolForKey(kRemindLater)
        if (hasDeclinedToRate) {
            return false
        }
        if (hasRatedCurrentVersion) {
            return false
        }
        if (hasChosenRemindLater) {
            let remindLaterDate = prefs.objectForKey(kFirstUseDate) as! NSDate
            let timeInterval = NSDate().timeIntervalSinceDate(remindLaterDate)
            let remindLaterDaysCount = ((timeInterval / 3600) / 24)
            return (remindLaterDaysCount >= daysBeforeReminding)
        }
        if (usageCount >= promptAfterUses) {
            return true
        }
        if (daysCount >= promptAfterDays) {
            return true
        }
        if (eventsCount >= promptAfterCustomEventsCount) {
            return true
        }
        return false
    }
    
    private func showRatingAlert() {
        let infoDocs: NSDictionary = NSBundle.mainBundle().infoDictionary!
        let appName: NSString = infoDocs.objectForKey("CFBundleName") as! NSString
        var message = NSLocalizedString("If you've enjoyed %@, please take a moment to rate it! Good ratings are pun-necessary!", comment: "RateMyApp")
        message = String(format:message, appName)
        if (count(alertMessage) == 0) {
            alertMessage = message
        }
        if (!hasOSB()) {
            var alert  = UIAlertView()
            alert.title = alertTitle
            alert.message = alertMessage
            alert.addButtonWithTitle(alertCancelTitle)
            alert.addButtonWithTitle(alertReminderTitle)
            alert.addButtonWithTitle(alertOKTitle)
            alert.delegate = self
            alert.show()
        } else {
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: alertOKTitle, style: .Destructive, handler: { alertAction in
                self.okButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: alertCancelTitle, style: .Cancel, handler: { alertAction in
                self.cancelButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: alertReminderTitle, style: .Default, handler: { alertAction in
                self.remindLaterButtonPressed()
                alert.dismissViewControllerAnimated(true, completion: nil)
            }))
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            let controller = appDelegate.window?.rootViewController
            controller?.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    internal func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        if (buttonIndex == 0) {
            cancelButtonPressed()
        } else if (buttonIndex == 1) {
            remindLaterButtonPressed()
        } else if (buttonIndex == 2) {
            okButtonPressed()
        }
        alertView.dismissWithClickedButtonIndex(buttonIndex, animated: true)
    }
    
    private func deviceOSVersion() -> Float {
        let device: UIDevice = UIDevice.currentDevice()
        let systemVersion = device.systemVersion
        let iOSVersion: Float = (systemVersion as NSString).floatValue
        return iOSVersion
    }
    
    private func hasOSB() -> Bool {
        if (deviceOSVersion() < 8.0) {
            return false
        }
        return true
    }
    
    private func okButtonPressed() {
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: kDidRateVersion)
        let appStoreURL = NSURL(string: reviewURLiOS7+appID)
        UIApplication.sharedApplication().openURL(appStoreURL!)
    }
    
    private func cancelButtonPressed() {
        NSUserDefaults.standardUserDefaults()
    }
    
}