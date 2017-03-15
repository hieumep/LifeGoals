//
//  ConvenientClass.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/15/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import Foundation
import CoreData

class ConvenientClass {
    class func shareInstance() -> ConvenientClass {
        struct Static{
            static let instance = ConvenientClass()
        }
        return Static.instance
    }
    
    lazy var context : NSManagedObjectContext = {
        return CoreDataStackManager.SharedInstance().managedObjectContext
    }()
    
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
    
    func saveContext(){
        CoreDataStackManager.SharedInstance().saveContext()
    }
}

    

//1.	You are never too old to set another goal or to dream a new dream -Les Brown
//2.	A dream becomes a goad when action is taken toward its achievement - Bo Bennett
//3.	The discipline you learn and character you build from setting and achieving a goad can be more valuable than the achievement of the goal itself - Bo Bennett
//4.	Just be yourself. Be honest, work towards a goad and you will achieve it - Emraan Hashmi
//5.	When it is obvious that the goal cannot be reached, don't adjust the goals, adjust the action steps - Confucius
//6.	Set your goal high and don't stop still you get there - Bo Jackson
//7.	Set your goals. But don't become frustrated because there are no obvious victories. Remind yourself that striving can be more important than arriving - Marvin J. Ashton
//8.	Keep your goals out of reach, but not out of sight - Jonathan Bergman
//9.	Dreaming is wonderful, goal setting is crucial, but action is supreme. - Greg Werner
//10.	A goal without a plan is just a wish - Antoine de Saint
//11.	Set a goal that makes you want to jump out of the bed in the morning - The colour run
//12.	There are no negatives in life, only challenges to overcome that will make you stronger - Eric R.Bates
//13.	Life is 10% what happens to us and 90% how we react to it - Dennis P. Kimbro
//14.	The great thing in this world is not so much where you stand, as in what direction you are moving - Oliver Wendell Holmen
//15.	Live each day as if your life had just begun - Johanm Wellgang Ven Geethe
//16.	The difference between a successful person and others is not lack of strength, not a lack of knowledge but rather a lack of will  - Vince Lombardi
//17.	If not us, who? If not now, when? - John F. Kennedy
//18.	Don't worry about failures, worry about the chances you miss when you don't even try - Jack Canfield
//19.	Do not let what you cannot do interfere with what you can do - John Wooden
//20.	Challenges are what make life interesting and overcoming them is what makes life meaningful - Joshua J.Marine
//21.	Yesterday is not ours to recover, but tomorrow is ours to win or lose - Lyndon B.Johnson
//22.	Success doesn't happen overnight. Keep your eye on the prize and don't look back - Erin Andrews
//23.	The tragedy of life doesn't lie in not reaching your goal. The tragedy lies in having no goals to reach - BEnjamin Mays
//24.	If you want to live a happy life, tie it to a goal. Not to people or things. - Albert Einstein

