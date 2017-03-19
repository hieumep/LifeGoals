//
//  AppDelegate.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import UserNotifications


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pointDictonary : [Int:Int16] = [0:0,1:3,2:4,3:5,4:6,5:7]
    let prefs = UserDefaults.standard
    let numberTurnRateApp = 20
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //setup navigation bar color
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(named: "NavigationBG"), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
        
        //ask permision turn on notification 
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]){ (accept, error) in
            if !accept {
                print("Sorry, they don't want")
            } else {
                let category = UNNotificationCategory(identifier: "remidSetGoal", actions: [], intentIdentifiers: [], options: [])
                UNUserNotificationCenter.current().setNotificationCategories([category])
            }
        }
       
        //setup some user setting varibale
        setupUserSetting()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        if  !ConvenientClass.shareInstance().checkLiveGoal() {
            ConvenientClass.shareInstance().getQuoteNotfication()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        ConvenientClass.shareInstance().checkExpired()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func setupUserSetting() {
        if prefs.value(forKey: "points") == nil {
            prefs.set(100, forKey: "points")
            prefs.set(0, forKey: "stars")
            prefs.set("Goal achivier", forKey: "name")
            prefs.set("", forKey: "imageProfile")
        }
        
        if prefs.value(forKey: "quotes") == nil {
            if ConvenientClass.shareInstance().insertQuotesIntoDatabase() {
                prefs.set(1, forKey: "quotes")
            }
        }
        
        if prefs.value(forKey: "rateReview") ==  nil {
            prefs.set(1, forKey: "rateReview")
        } else {
            var numberOfActiveApp = prefs.value(forKey: "rateReview") as! Int
            numberOfActiveApp += 1
            print(numberOfActiveApp)
            prefs.set(numberOfActiveApp, forKey: "rateReview")
            if numberOfActiveApp == numberTurnRateApp {
                DispatchQueue.main.async(execute: {
                    let alertVC = ConvenientClass.shareInstance().rateReviewApp(appId: "1116877061")
                    self.window?.rootViewController?.present(alertVC, animated: true, completion: nil)
                })

            }
        }
    }
    
}

