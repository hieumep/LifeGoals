//
//  AppDelegate.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/20/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var pointDictonary : [Int:Int16] = [0:0,1:3,2:4,3:5,4:6,5:7]
    let prefs = UserDefaults.standard
    lazy var context : NSManagedObjectContext = {
       return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().setBackgroundImage(UIImage.init(named: "NavigationBG"), for: .default)
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
        UINavigationBar.appearance().tintColor = UIColor.white
       // UINavigationBar.appearance().backgroundColor = UIColor.init(red: 244/255, green: 105/255, blue: 0/255, alpha: 0.59)
        if prefs.value(forKey: "points") == nil {
            prefs.set(100, forKey: "points")
            prefs.set(0, forKey: "stars")
            prefs.set("Goal achivier", forKey: "name")
            prefs.set("", forKey: "imageProfile")
        }       
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
        checkExpired()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func checkExpired() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "done == false")
        do {
            let goalItems = try context.fetch(fetchRequest) as! [Goal]
            for item in goalItems {
                let expiredDate = item.expiredDate as! Date
                let curreDate = Date()
                if !item.done {
                    if curreDate.compare(expiredDate) != .orderedAscending {
                        item.done = true
                        item.stars = 1
                        item.points = -5
                        var points = prefs.integer(forKey: "points")
                        var stars = prefs.integer(forKey: "stars")
                        points = points - 5
                        stars = stars + 1
                        prefs.set(points, forKey: "points")
                        prefs.set(stars, forKey: "stars")
                    }
                }
            }
        
        }catch {
                print(error)
                abort()
        }
        saveContext()
    }
}

