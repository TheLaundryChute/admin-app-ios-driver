//
//  AppDelegate.swift
//  TLCAdmin
//
//  Created by Stephen Bechtold on 8/2/16.
//  Copyright © 2016 The Laundry Chute. All rights reserved.
//

import UIKit
import InMotionUI
import Fabric
import Crashlytics


@UIApplicationMain
class AppDelegate: InMotionUIAppDelegate {
    
    //
    //- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
    
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])

        return super.application(application, didFinishLaunchingWithOptions:launchOptions);
    }
    
    override var loginViewController: UIViewController? {
        get {
            return TLCAdmin.LoginViewController(nibName: "LoginView", bundle: nil);
        }
    }
}

