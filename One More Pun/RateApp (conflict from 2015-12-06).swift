//
//  RateApp.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit

class RateHyApp : UIViewController, UIAlertViewOelegate {
    
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
