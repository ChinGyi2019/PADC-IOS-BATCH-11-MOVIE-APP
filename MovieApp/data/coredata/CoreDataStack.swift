//
//  CoreDataStack.swift
//  MovieApp
//
//  Created by Van Za Lyan Htan on 05/08/2021.
//

import Foundation

import Foundation
import CoreData

class CoreDataStack : NSObject{
    
    static let shared = CoreDataStack()
    
    let persistentContainer : NSPersistentContainer
    
    var context : NSManagedObjectContext{
        get {
            persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
            
            return persistentContainer.viewContext
        }
    }
    
    private override init(){
        //Here Big Notice container name must be equal to the name of your xcdatamodel
        persistentContainer = NSPersistentContainer(name: "MovieApp")
        persistentContainer.loadPersistentStores{ (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolve Error: \(error)")
            }
        }
    }
    
    func saveContext(){
        let context = self.context
        if context.hasChanges{
            do {
                try context.save()
            } catch {
                let error = error as NSError
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
}
