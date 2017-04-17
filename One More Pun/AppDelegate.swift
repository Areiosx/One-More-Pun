//
//  AppDelegate.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FIRApp.configure()
        
        incrementLaunchCount()
        
        return true
    }
    
    func incrementLaunchCount() {
        let currentCount = UserDefaults.standard.integer(forKey: .launchCountKey)
        UserDefaults.standard.set(currentCount + 1, forKey: .launchCountKey)
        UserDefaults.standard.synchronize()
    }
}
