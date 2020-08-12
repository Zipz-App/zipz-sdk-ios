//
//  Category+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension Category
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<Category> = Category.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func save(_ new: Category)
    {
        guard let _ = Category.fetch(with: new.name) else {

            context().insert(new)
            ZipzDatabase.saveContext()
            return
        }
    }
    
    static func fetch(with name: String) -> Category?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "name == %@", name)
        
        var object: Category?
        do  { object = try context().fetch(request).first }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching CATEGORY with NAME \(name): \(error.userInfo)")
        }
        return object
    }
    
    static func all() -> [Category]?
    {
        request.returnsObjectsAsFaults = false
        
        var objects: [Category]?
        do  { objects = try context().fetch(request) }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching all CATEGORIES: \(error.userInfo)")
        }
        return objects
    }
}
