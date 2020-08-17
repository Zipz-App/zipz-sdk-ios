//
//  DatabaseController.swift
//
//  Created by Mirko Trkulja on 01/12/2017.
//  Copyright © 2017 Mirko Trkulja. All rights reserved.
//

import Foundation
import CoreData

public class ZipzDatabase
{
    private static let context = persistentContainer.viewContext
    
    // MARK: - Init
    private init(){}
        
    // MARK: - CoreData
    static var persistentContainer: NSPersistentContainer = {
        
            let messageKitBundle = Bundle(identifier: "app.zipz.sdk")
            let modelURL = messageKitBundle!.url(forResource: "ZipzSDK", withExtension: "momd")!
            let managedObjectModel =  NSManagedObjectModel(contentsOf: modelURL)
        
            let container = NSPersistentContainer(name: "ZipzSDK", managedObjectModel: managedObjectModel!)
            container.loadPersistentStores(completionHandler: {
                
                (storeDescription, error) in
                
                if let error = error as NSError? {
                    assert(true, "Unresolved error \(error), \(error.userInfo)")
                }
            })
            
            return container
    }()
    
    // MARK: - ContextSaving
    public class func saveContext()
    {
        if context.hasChanges
        {
            do { try context.save() }
            catch let nserror as NSError
            {
                // do not crash. think of something.
                ZipzSDK.debugLog("Unresolved CORE DATA error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
