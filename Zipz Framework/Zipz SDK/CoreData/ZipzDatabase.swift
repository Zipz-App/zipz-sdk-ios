//
//  DatabaseController.swift
//
//  Created by Mirko Trkulja on 01/12/2017.
//  Copyright © 2017 Mirko Trkulja. All rights reserved.
//

import Foundation
import CoreData

//  Core Data stack controller with support for iOS 9 and earlier
class ZipzDatabase
{
    private static let context = persistentContainer.viewContext
    
    // MARK: - Init
    private init(){}
        
    // MARK: - CoreData
    static var persistentContainer: NSPersistentContainer =
        {
            let container = NSPersistentContainer(name: "Zipz_Framework")
            
            container.loadPersistentStores(completionHandler: {
                
                (storeDescription, error) in
                
                if let error = error as NSError? {
                    assert(true, "Unresolved error \(error), \(error.userInfo)")
                }
            })
            
            return container
    }()
    
    // MARK: - ContextSaving
    class func saveContext()
    {
        if context.hasChanges
        {
            do { try context.save() }
            catch let nserror as NSError
            {
                // do not crash. think of something.
                debugLog("Unresolved CORE DATA error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
