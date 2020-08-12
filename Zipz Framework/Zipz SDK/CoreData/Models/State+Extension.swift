//
//  State+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 09/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension State
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<State> = State.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func save(_ new: State)
    {
        if let saved = State.fetch(with: new.id) {
            saved.name = new.name
        }
        else {
            context().insert(new)
        }
        ZipzDatabase.saveContext()
    }
    
    static func fetch(with id: Int16) -> State?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", id)
        
        var state: State?
        do  { state = try context().fetch(request).first }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching STATE with ID \(id): \(error.userInfo)")
        }
        return state
    }
    
    static func all() -> [State]?
    {
        request.returnsObjectsAsFaults = false
        
        var states: [State]?
        do  { states = try context().fetch(request) }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching all STATES: \(error.userInfo)")
        }
        return states
    }
}
