//
//  Cluster+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension Cluster
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<Cluster> = Cluster.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }

    public static func fetch(with uuid: String) -> Cluster?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        var object: Cluster?
        do  { object = try context().fetch(request).first }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching CLUSTER with ID \(uuid): \(error.userInfo)")
        }
        return object
    }
    
    public static func all() -> [Cluster]?
    {
        request.returnsObjectsAsFaults = false
        
        var objects: [Cluster]?
        do  { objects = try context().fetch(request) }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching all CLUSTERS: \(error.userInfo)")
        }
        return objects
    }
}
