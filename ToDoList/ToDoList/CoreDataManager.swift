//
//  CoreDataManager.swift
//  ToDoList
//
//  Created by Chichek on 06.12.24.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoList")
        
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("\(error)")
            }
        }
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(nserror)")
            }
        }
    }
}

