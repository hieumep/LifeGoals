//
//  QuoteObject.swift
//  Life Goals
//
//  Created by Hieu Vo on 3/8/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//

import CoreData

class QuoteObject : NSManagedObject {
    struct keys {
        static let quote = "quote"
        static let author = "author"
    }
    
    @NSManaged var quote : String
    @NSManaged var author : String
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(quoteItem : [String:AnyObject], context : NSManagedObjectContext) {
        let entity = NSEntityDescription.entity(forEntityName: "Quote", in: context)
        super.init(entity: entity!, insertInto: context)
        quote = quoteItem[keys.quote] as! String
        author = quoteItem[keys.author] as! String
    }
}
