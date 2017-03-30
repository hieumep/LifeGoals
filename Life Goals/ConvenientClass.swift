//
//  ConvenientClass.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/15/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import CoreData
import UserNotifications
import UIKit
import Firebase

class ConvenientClass {
    class func shareInstance() -> ConvenientClass {
        struct Static{
            static let instance = ConvenientClass()
        }
        return Static.instance
    }
    
    let prefs = UserDefaults()
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()    
    
    //set category of UserNotifications
    let category = UNNotificationCategory(identifier: "", actions: [], intentIdentifiers: [], options: [])
    
    //get random Quote from database
    func getRandomQuote() -> (author : String,quote : String) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Quote")
        var quote : (author : String,quote : String) = ("","")
        do {
            let fetchResults = try context.fetch(fetchRequest)
            if fetchResults.count > 0 {
                let indexRandom = Int(arc4random_uniform(UInt32(fetchResults.count)))
                let item = fetchResults[indexRandom] as! Quote
                quote.author = item.author!
                quote.quote = item.quote!
            }
        }catch{
            print(error)
        }
        return quote
    }
    
    //declare some initial Quots
    lazy var beginQuotes : [String: String] = {
        var quoteDic = [String : String]()
        quoteDic["Les Brown"] = "You are never too old to set another goal or to dream a new dream"
       // quoteDic["Bo Bennett"] = "A dream becomes a goad when action is taken toward its achievement"
        quoteDic["Bo Bennett"] = "The discipline you learn and character you build from setting and achieving a goad can be more valuable than the achievement of the goal itself"
        quoteDic["Emraan Hashmi"] = "Just be yourself. Be honest, work towards a goad and you will achieve it"
        quoteDic["Confucius"] = "When it is obvious that the goal cannot be reached, don't adjust the goals, adjust the action steps"
        quoteDic["Bo Jackson"] = "Set your goal high and don't stop still you get there"
        quoteDic["Marvin J. Ashton"] = "Set your goals. But don't become frustrated because there are no obvious victories. Remind yourself that striving can be more important than arriving"
        quoteDic["Jonathan Bergman"] = "Keep your goals out of reach, but not out of sight"
        quoteDic["Greg Werner"] = "Dreaming is wonderful, goal setting is crucial, but action is supreme."
        quoteDic["Antoine de Saint"] = "A goal without a plan is just a wish"
        quoteDic["The colour run"] = "Set a goal that makes you want to jump out of the bed in the morning"
        quoteDic["Eric R.Bates"] = "There are no negatives in life, only challenges to overcome that will make you stronger"
        quoteDic["Dennis P. Kimbro"] = "Life is 10% what happens to us and 90% how we react to it"
        quoteDic["Oliver Wendell Holmen"] = "The great thing in this world is not so much where you stand, as in what direction you are moving"
        quoteDic["Johanm Wellgang Ven Geethe"] = "Live each day as if your life had just begun"
        quoteDic["Vince Lombardi"] = "The difference between a successful person and others is not lack of strength, not a lack of knowledge but rather a lack of will"
        quoteDic["John F. Kennedy"] = "If not us, who? If not now, when?"
        quoteDic["Jack Canfield"] = "Don't worry about failures, worry about the chances you miss when you don't even try"
        quoteDic["John Wooden"] = "Do not let what you cannot do interfere with what you can do"
        quoteDic["Joshua J.Marine"] = "Challenges are what make life interesting and overcoming them is what makes life meaningful"
        quoteDic["Lyndon B.Johnson"] = "Yesterday is not ours to recover, but tomorrow is ours to win or lose"
        quoteDic["Erin Andrews"] = "Success doesn't happen overnight. Keep your eye on the prize and don't look back"
        quoteDic["Benjamin Mays"] = "The tragedy of life doesn't lie in not reaching your goal. The tragedy lies in having no goals to reach"
        quoteDic["Albert Einstein"] = "If you want to live a happy life, tie it to a goal. Not to people or things."
        return quoteDic
    }()
    
    //insert inital quotes into Database
    func insertQuotesIntoDatabase() -> Bool {
        if beginQuotes.count > 0 {
            for quote in beginQuotes {
                var item = [String : AnyObject]()
                item[QuoteObject.keys.author] = quote.key as AnyObject?
                item[QuoteObject.keys.quote] = quote.value as AnyObject?
                _ = QuoteObject.init(quoteItem: item, context: context)
                saveContext()
            }
            return true
        }else {
            return false
        }
    }
    
    // check goal's expired day
    func checkExpired() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "done == false")
        do {
            let goalItems = try context.fetch(fetchRequest) as! [Goal]
            for item in goalItems {
                let expiredDate = item.expiredDate! as Date
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

    //get quote Notification 
    func getQuoteNotfication(){
        let quote = getRandomQuote()
        var content = [String : String]()
        content["title"] = quote.author
        content["body"] = quote.quote
        let newDate = Date().addingTimeInterval(43200)
        scheduleNotification(at: newDate, contentNotification: content)
    }
    
    //check live goal 
    func checkLiveGoal() -> Bool{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "done == false")
        do {
            let goalItems = try context.fetch(fetchRequest) as! [Goal]
            if goalItems.count < 1 {
                var content = [String : String]()
                content["title"] = "Remind set goal"
                content["body"] = "You should set goal to be success"
                let newDate = Date().addingTimeInterval(43200)
                scheduleNotification(at: newDate, contentNotification: content)
                return true
            }
        }catch {
            print(error)
            abort()
        }
        return false

    }


    //make notification
    func scheduleNotification(at date : Date, contentNotification : [String : String]) {
        let calendar = Calendar(identifier: .gregorian)
        let dateComponents = calendar.dateComponents(in : .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, year: dateComponents.year, month: dateComponents.month, day: dateComponents.day, hour: dateComponents.hour, minute: dateComponents.minute)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = contentNotification["title"]!
        content.body = contentNotification["body"]!
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "remindSetGoal"
        
        let request = UNNotificationRequest(identifier: "setGoal", content: content, trigger: trigger)
        
       // UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().add(request) {(error) in
            if let error = error {
                print("Uh oh! We had an error: \(error)")
            }
        }
    
    }
    
    //func call alert rate app 
    func rateReviewApp(appId: String) -> UIAlertController{
        let alertVC = UIAlertController(title: "Rate and Review", message: "Tell everyone how about you love app", preferredStyle: .alert)
        
        let rateAction = UIAlertAction(title: "Rate and Review", style: .default, handler: { action in            
            let url = URL(string : "itms-apps://itunes.apple.com/gb/app/id" + appId + "?action=write-review&mt=8")
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(url!, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url!)
            }
            
        })
        
        let laterAction = UIAlertAction(title: "Maybe Later", style:.default, handler: { action in
            self.prefs.set(0, forKey: "rateReview")
    })    
        alertVC.addAction(rateAction)
        alertVC.addAction(laterAction)
        return alertVC
    }
    //save data
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
}

    


