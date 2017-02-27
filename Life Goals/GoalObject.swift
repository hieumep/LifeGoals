//
//  GoalObject.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/23/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import CoreData

class GoalObject : NSManagedObject {
    struct keys {
        static let goal = "goal"
        static let goalDescription = "goalDescription"
        static let shortTerm = "shortTerm"
        static let expiredDate = "expiredDate"
        static let photo_path = "photo"
    //    static let idGoal = "idGoal"
        static let done = "done"
        static let dateDone = "dateDone"
        static let point = "point"
        static let star = "star"
        static let createdDate = "createdDate"
        static let experience = "experience"
        static let notes = "notes"
    }
    
    @NSManaged var goal : String?
    @NSManaged var goalDescription : String?
    @NSManaged var shortTerm : Bool
    @NSManaged var expiredDate : NSDate
    @NSManaged var photo : String?
   // @NSManaged var idGoal : Int64
    @NSManaged var done : Bool
    @NSManaged var dateDone : NSDate?
    @NSManaged var point : Int64
    @NSManaged var star : Int64
    @NSManaged var createdDate : NSDate
    @NSManaged var experience : String?
    @NSManaged var notes : [Note]?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(goalItem : [String: AnyObject], context: NSManagedObjectContext?) {
        let goalEntity = NSEntityDescription.entity(forEntityName: "Goal", in: context!)
        super.init(entity: goalEntity!, insertInto: context)
     //   idGoal = goalItem[keys.idGoal] as! Int64
        goal = goalItem[keys.goal] as? String
        goalDescription = goalItem[keys.goalDescription] as? String
        shortTerm = goalItem[keys.shortTerm] as! Bool
        point = 0
        star = 0
        expiredDate = goalItem[keys.expiredDate] as! NSDate
        createdDate = goalItem[keys.createdDate] as! NSDate
        photo = goalItem[keys.photo_path] as? String
    }
}
