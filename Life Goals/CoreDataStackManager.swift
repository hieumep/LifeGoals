//
//  CoreDataStackManager.swift
//  Life Goals
//
//  Created by Hieu Vo on 2/22/17.
//  Copyright © 2017 Hieu Vo. All rights reserved.
//
// This class for Core Data Convenience
import CoreData

private let SQLite_File_Name = "SqliteData.sqlite"

class CoreDataStackManager {
    class func SharedInstance() -> CoreDataStackManager {
        struct Static {
            static let instance = CoreDataStackManager()
        }
        return Static.instance
    }
    
    lazy var applicationDocumentDirector : URL = {
        let URLs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return URLs[URLs.count - 1]
    }()
    
    lazy var managedObjectModel : NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "DataModel", withExtension: "momd")!
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL)
        return managedObjectModel!
    }()
    
    lazy var persistentStoreCoodinator : NSPersistentStoreCoordinator = {
        let coordinator : NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentDirector.appendingPathComponent(SQLite_File_Name)
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            print(error)
            abort()
        }
        return coordinator
    }()
    
    lazy var managedObjectContext : NSManagedObjectContext = {
       let managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.persistentStoreCoodinator
        return managedObjectContext
    }()
    
    //Save Context when something had changed in Data
    func saveContext(){
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            } catch {
                print(error)
                abort()
            }
        }
    }
}
