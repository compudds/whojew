//
//  AppDelegate.swift
//  WhoJew
//
//  Created by Eric Cook on 3/18/15.
//  Copyright (c) 2015 Better Search, LLC. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PushNotificationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Parse.setApplicationId("eA3Y2C64we0zyp5GMvwgsLdSjfQzlGwaWBr04vO7", clientKey: "5FqGMb8JR9drScb24GdTCB86XJQl2RuiSfBkg9wp")
        
        Parse.enableLocalDatastore()
        
        let parseConfiguration = ParseClientConfiguration(block: { (ParseMutableClientConfiguration) -> Void in
            ParseMutableClientConfiguration.applicationId = "eA3Y2C64we0zyp5GMvwgsLdSjfQzlGwaWBr04vO"
            ParseMutableClientConfiguration.clientKey = "NPGFS4QNzVhn6R5PtiOWhakg6uX7VBIst9uDBCa"
            ParseMutableClientConfiguration.server = "https://whojew.herokuapp.com/parse"
        })
        
        Parse.initialize(with: parseConfiguration)
        
        PushNotificationManager.push().delegate = self
        PushNotificationManager.push().handlePushReceived(launchOptions)
        PushNotificationManager.push().sendAppOpen()
        PushNotificationManager.push().registerForPushNotifications()
        
        //PFUser.enableAutomaticUser()
        
        //var pushSettings:UIUserNotificationSettings = UIUserNotificationSettings(forTypes: .Alert, categories: nil)
        let pushSettings:UIUserNotificationSettings = UIUserNotificationSettings(types: [UIUserNotificationType.badge, UIUserNotificationType.sound, UIUserNotificationType.alert], categories: nil)
        application.registerUserNotificationSettings(pushSettings)
        application.registerForRemoteNotifications()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {                 let currentInstallation: PFInstallation = PFInstallation.current()
        currentInstallation.setDeviceTokenFrom(deviceToken)
        currentInstallation.saveEventually()
        
        print(deviceToken)
        
        PushNotificationManager.push().handlePushRegistration(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error:Error) {
        print(error)
        
        PushNotificationManager.push().handlePushRegistrationFailure(error)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {         PFPush.handle(userInfo)
     
        PushNotificationManager.push().handlePushReceived(userInfo)
        
    }
    
    func onPushAccepted(_ pushManager: PushNotificationManager!, withNotification pushNotification: [AnyHashable: Any]!, onStart: Bool) {
        print("Push notification accepted: \(String(describing: pushNotification))");
    }


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

