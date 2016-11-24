//
//  RateApp.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit

class RateMyApp : UIViewController, UIAlertViewDelegate {
    
    fileprivate let kTrackingAppVersion = "kRateMyApp_TrackingAppVersion"
    fileprivate let kFirstUseDate = "kRateMyApp_FirstUseDate"
    fileprivate let kAppUseCount = "kRateMyApp_AppUseCount"
    fileprivate let kSpecialEventCount = "kRateHyApp_SpecialEventCount"
    fileprivate let kDidRateVersion = "kRateMyApp_DidRateVersion"
    fileprivate let kDeclinedToRate = "kRateMyApp_DeclinedToRate"
    fileprivate let kRemindLater = "kRateMyApp_RemindLater"
    fileprivate let kRemindLaterPressedDate = "kRateHyApp_RemindLaterPressedDate"
    fileprivate var reviewURL = "itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=1008575898&onlyLatestVersion=true&pageNumber=0&sortOrdering=1&type=Purple+Software"
    
    let promptAfterDays: Double = 5
    let promptAfterUses = 3
    let promptAfterCustomEventsCount = 10
    let daysBeforeReminding: Double = 1
    
    let alertTitle = NSLocalizedString("Like puns?", comment: "RateMyApp")
    var alertMessage = ""
    let alertOKTitle = NSLocalizedString("5 Stars!", comment: "RateMyApp")
    let alertCancelTitle = NSLocalizedString("Never! I hate happiness!", comment: "RateMyApp")
    let alertReminderTitle = NSLocalizedString("Maybe later, let me see some puns first.", comment: "RateMyApp")
    var appID = "1008575898"
    
    class var sharedInstance: RateMyApp {
        struct Static {
            static let instance: RateMyApp = RateMyApp()
        }
        return Static.instance
    }
    
    internal required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    fileprivate override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    fileprivate func initAllSettings() {
        let prefs = UserDefaults.standard
        
        prefs.set(getCurrentAppVersion(), forKey: kTrackingAppVersion)
        prefs.set(Date(), forKey: kFirstUseDate)
        prefs.set(1, forKey: kAppUseCount)
        prefs.set(0, forKey: kSpecialEventCount)
        prefs.set(false, forKey: kDidRateVersion)
        prefs.set(false, forKey: kDeclinedToRate)
        prefs.set(false, forKey: kRemindLater)
    }
    
    func trackEventUsage() {
        incrementValueForKey(kSpecialEventCount)
    }
    
    func trackAppUsage() {
        incrementValueForKey(kAppUseCount)
    }
    
    fileprivate func isFirstTime() -> Bool {
        let prefs = UserDefaults.standard
        let trackingAppVersion = prefs.object(forKey: kTrackingAppVersion) as? NSString
        if ((trackingAppVersion == nil) || !(getCurrentAppVersion().isEqual(to: trackingAppVersion!as String))) {
            return true
        }
        return false
    }
    
    fileprivate func incrementValueForKey(_ name: String) {
        if (appID.characters.count == 0) {
            fatalError("Set iTunes Connect appID to proceed, you may enter some random string for testing purposes. See line number 34.")
        }
        if(isFirstTime()) {
            initAllSettings()
        } else {
            let prefs  = UserDefaults.standard
            let currentCount = prefs.integer(forKey: name)
            prefs.set(currentCount+1, forKey: name)
        }
        if (shouldShowAlert()) {
            showRatingAlert()
        }
    }
    
    fileprivate func shouldShowAlert() -> Bool {
        let prefs = UserDefaults.standard
        let usageCount = prefs.integer(forKey: kAppUseCount)
        let eventsCount = prefs.integer(forKey: kSpecialEventCount)
        let firstUse = prefs.object(forKey: kFirstUseDate) as! Date
        let timeInterval = Date().timeIntervalSince(firstUse)
        let daysCount = ((timeInterval / 3600) / 24)
        let hasRatedCurrentVersion = prefs.bool(forKey: kDidRateVersion)
        let hasDeclinedToRate = prefs.bool(forKey: kDeclinedToRate)
        let hasChosenRemindLater = prefs.bool(forKey: kRemindLater)
        if (hasDeclinedToRate) {
            return false
        }
        if (hasRatedCurrentVersion) {
            return false
        }
        if (hasChosenRemindLater) {
            let remindLaterDate = prefs.object(forKey: kFirstUseDate) as! Date
            let timeInterval = Date().timeIntervalSince(remindLaterDate)
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
    
    fileprivate func showRatingAlert() {
        let infoDocs: NSDictionary = Bundle.main.infoDictionary! as NSDictionary
        let appName: NSString = infoDocs.object(forKey: "CFBundleName") as! NSString
        var message = NSLocalizedString("If you've enjoyed %@, please take a moment to rate it! Good ratings are pun-necessary!", comment: "RateMyApp")
        message = String(format:message, appName)
        if (alertMessage.characters.count == 0) {
            alertMessage = message
        }
            let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: alertOKTitle, style: .default, handler: { alertAction in
                self.okButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: alertCancelTitle, style: .cancel, handler: { alertAction in
                self.cancelButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: alertReminderTitle, style: .default, handler: { alertAction in
                self.remindLaterButtonPressed()
                alert.dismiss(animated: true, completion: nil)
            }))
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let controller = appDelegate.window?.rootViewController
            controller?.present(alert, animated: true, completion: nil)
    }
    
    fileprivate func deviceOSVersion() -> Float {
        let device: UIDevice = UIDevice.current
        let systemVersion = device.systemVersion
        let iOSVersion: Float = (systemVersion as NSString).floatValue
        return iOSVersion
    }
    
    fileprivate func hasOSB() -> Bool {
        if (deviceOSVersion() < 8.0) {
            return false
        }
        return true
    }
    
    fileprivate func okButtonPressed() {
        UserDefaults.standard.set(true, forKey: kDidRateVersion)
        let appStoreURL = URL(string: reviewURL)
        guard let url = appStoreURL else { return }
        UIApplication.shared.openURL(url)
    }
    
    fileprivate func cancelButtonPressed() {
        UserDefaults.standard.set(true, forKey: kDeclinedToRate)
    }
    
    fileprivate func remindLaterButtonPressed() {
        UserDefaults.standard.set(true, forKey: kRemindLater)
        UserDefaults.standard.set(Date(), forKey: kRemindLaterPressedDate)
    }
    
    fileprivate func getCurrentAppVersion() -> NSString {
        return (Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! NSString)
    }
    
}
