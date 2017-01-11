//
//  AppDelegate.swift
//  Lesson 18 - Simple Chat Http Client
//
//  Created by Elad Lavi on 11/09/2016.
//  Copyright © 2016 HackerU LTD. All rights reserved.
//

import UIKit



protocol BackgroundDelegate {
    func didEnterBackground();
    func didEnterForeground();
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var backgroundDelegate: BackgroundDelegate?;
    
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        if let delegate = backgroundDelegate{
            delegate.didEnterBackground();
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        if let delegate = backgroundDelegate{
            delegate.didEnterForeground();
        }
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

