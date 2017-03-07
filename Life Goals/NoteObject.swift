//
//  NoteObject.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/23/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import CoreData

class NoteObject :NSManagedObject {
    
    struct keys {
        static let note = "note"
        static let noteDescription = "noteDescription"
        static let done = "done"
        static let photo_path = "photo"
        static let goals = "goals"
    }
    
    @NSManaged var note : String
    @NSManaged var noteDescription : String?
    @NSManaged var done : Bool
    @NSManaged var photo : String?
    @NSManaged var goals : Goal?
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(noteItem : [String:AnyObject], context : NSManagedObjectContext?){
        let noteEntity = NSEntityDescription.entity(forEntityName: "Note", in: context!)
        super.init(entity: noteEntity!, insertInto: context)
        note = noteItem[keys.note] as! String
        noteDescription = noteItem[keys.noteDescription] as? String
       // done = noteItem[keys.done] as! Bool
        photo = noteItem[keys.photo_path] as? String
        goals = noteItem[keys.goals] as? Goal
    }
}
