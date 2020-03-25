//
//  AppDelegate.swift
//  FastboxDriver
//
//  Created by Apple on 11/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import GoogleMaps
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        GMSServices.provideAPIKey(Constants.GoogleMapsApiKey)
        
        if launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] != nil {
          print(launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification])
        }

        register_To_Push_Notifications(application: application)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    //MARK:- Helper Methods
    
    func update(withDeviceToken deviceToken:String,withDriverId driverId:Int) {
        let url = "\(UrlConstants.BaseUrl)\(UrlConstants.UpdateDeviceToken)"
        let params:[String:Any] = ["driverId":driverId,"device_token":deviceToken,"device_type":"2"]
        User.postString(withUrl: url, withParameters: params as [String : AnyObject], withHeader: UrlConstants.Header, success: { (msg) in
            print(msg)
            print("Updated Device token")
        }) { (error) in
            print(error)
        }
    }
    
    
    //MARK:- Setup Methods
    
    func register_To_Push_Notifications(application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert,.sound,.badge]) { (granted, error) in
                
                if error == nil {
                    print("Permission: \(granted)")
                    guard granted else { return }
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                    
                } else {
                    print("Error is: \(error?.localizedDescription)")
                }
                
                //                self.get_Notification_Settings()
            }
        } else {
            let notificationSettings = UIUserNotificationSettings(types: [.badge, .sound, .alert], categories: nil)
            application.registerUserNotificationSettings(notificationSettings)
        }
    }
    
    
    func get_Notification_Settings() {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().getNotificationSettings { (settings) in
                print("Notification settings are: \(settings)")
                guard settings.authorizationStatus == .authorized else { return }
                UIApplication.shared.registerForRemoteNotifications()
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    //MARK:- Notification Registration Methods
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("Token is: \(token)")
        
        if token != "" {
            UserDefaults.standard.set(token, forKey: Constants.DeviceToken)
        } else {
            UserDefaults.standard.set("", forKey: Constants.DeviceToken)
        }
        if UserDefaults.standard.object(forKey: Constants.sharedInstance.UserData) != nil && token != "" {
            Constants.userObj = UtilityClass.decodeObject(Constants.sharedInstance.UserData) as! User
            update(withDeviceToken: token, withDriverId: Constants.userObj.user_id)
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for remote notifications with error: \(error)")
    }

    //MARK:- UNNotificationCenter Delegate Methods
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        //Handle Notification in foreground
        let userInfo = notification.request.content.userInfo as? [String:Any]
        print("\(userInfo)")
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //Handle Notification in background
        let userInfo = response.notification.request.content.userInfo as? [String:Any]
        print("\(userInfo)")
    }

}

