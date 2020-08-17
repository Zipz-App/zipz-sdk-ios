//
//  Transaction+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension Transaction
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    public static func fetch(with uuid: String) -> Transaction?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        var object: Transaction?
        do  { object = try context().fetch(request).first }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching CLUSTER with ID \(uuid): \(error.userInfo)")
        }
        return object
    }
    
    public static func all() -> [Transaction]?
    {
        request.returnsObjectsAsFaults = false
        
        var objects: [Transaction]?
        do  { objects = try context().fetch(request) }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching all CLUSTERS: \(error.userInfo)")
        }
        return objects
    }
}
