//
//  DailyNoteObject.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/14/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import CoreData

class DailyNoteObject : NSManagedObject {
    struct keys {
        static let dailyNote = "dailyNote"
        static let done = "done"
    }
    
    @NSManaged var dailyNote : String
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(item : [String:String], context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "DailyNote", in: context)
        super.init(entity: entity!, insertInto: context)
        dailyNote = item[keys.dailyNote]!
    }
}
