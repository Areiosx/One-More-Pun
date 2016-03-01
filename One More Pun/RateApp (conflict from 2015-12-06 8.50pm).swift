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
    private var reviewURLiOST = "https://itunes.apple.com/us[app/appName/id1008575898?mt=8"
    
    let promptAfterDays = 5
    let promptAfterUses = 3
    let promptAfterCustomEventsCount = 10
    let daysBeforeReminding = 1
    
    let alertTitle = NSLocalizedString("Like puns?", comment: "RateMyApp")
    let alertMessage = ""
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
    
    private override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?, )
    
}