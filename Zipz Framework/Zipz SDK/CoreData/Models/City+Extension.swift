//
//  City+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 10/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension City
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<City> = City.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func fetch(with id: Int16) -> City?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "id == %i", id)
        
        var city: City?
        do  { city = try context().fetch(request).first }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching CITY with ID \(id): \(error.userInfo)")
        }
        return city
    }
    
    static func all() -> [City]?
    {
        request.returnsObjectsAsFaults = false
        
        var cities: [City]?
        do  { cities = try context().fetch(request) }
            
        catch let error as NSError {
            debugLog("🧨 Error fetching all CITIES: \(error.userInfo)")
        }
        return cities
    }
}
