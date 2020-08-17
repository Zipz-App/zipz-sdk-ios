//
//  User+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension User
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<User> = User.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func save(_ new: User)
    {
        if let saved = User.fetch(with: new.uuid)
        {
            saved.email = new.email
            saved.name = new.name
            saved.surname = new .surname
            saved.birthday = new.birthday
            saved.gender = new.gender
            saved.cpf = new.cpf
            saved.phone = new.phone
        }
        else {
            context().insert(new)
        }
        ZipzDatabase.saveContext()
    }
    
    public static func fetch(with uuid: String) -> User?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        var user: User?
        do  { user = try context().fetch(request).first }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching USER with ID \(uuid): \(error.userInfo)")
        }
        return user
    }
    
    public static func authorized() -> User?
    {
        request.returnsObjectsAsFaults = false
        
        var user: User?
        do  { user = try context().fetch(request).first }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching authorized USER: \(error.userInfo)")
        }
        return user
    }
}
