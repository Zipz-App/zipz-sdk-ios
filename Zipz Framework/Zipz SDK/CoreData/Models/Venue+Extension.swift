//
//  Venue+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension Venue
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<Venue> = Venue.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func fetch(with uuid: String) -> Venue?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        var venue: Venue?
        do  { venue = try context().fetch(request).first }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching VENUE with UUID \(uuid): \(error.userInfo)")
        }
        return venue
    }
    
    static func all() -> [Venue]?
    {
        request.returnsObjectsAsFaults = false
        
        var venues: [Venue]?
        do  { venues = try context().fetch(request) }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching all VENUES: \(error.userInfo)")
        }
        return venues
    }
}
