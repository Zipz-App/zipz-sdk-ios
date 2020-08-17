//
//  Offer+Extension.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

extension Offer
{
    // MARK: - Static parameters
    static let request: NSFetchRequest<Offer> = Offer.fetchRequest()
    
    static func context() -> NSManagedObjectContext {
        return ZipzDatabase.persistentContainer.viewContext
    }
    
    static func save(_ new: Offer)
    {
        if let saved = Offer.fetch(with: new.uuid) {
            saved.name = new.name
            saved.info = new.info
            saved.image = new.image
            saved.status = new.status
            saved.quantity = new.quantity
            saved.expiration = new.expiration
            saved.offerPrice = new.offerPrice
            saved.fullPrice = new.fullPrice
            saved.categories = new.categories
            
        }
        else {
            context().insert(new)
        }
        ZipzDatabase.saveContext()
    }
    
    public static func fetch(with uuid: String) -> Offer?
    {
        request.returnsObjectsAsFaults = false
        request.fetchLimit = 1
        request.predicate = NSPredicate(format: "uuid == %@", uuid)
        
        var offer: Offer?
        do  { offer = try context().fetch(request).first }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching OFFER with UUID \(uuid): \(error.userInfo)")
        }
        return offer
    }
    
    public static func all() -> [Offer]?
    {
        request.returnsObjectsAsFaults = false
        
        var offers: [Offer]?
        do  { offers = try context().fetch(request) }
            
        catch let error as NSError {
            ZipzSDK.debugLog("🧨 Error fetching all OFFERS: \(error.userInfo)")
        }
        return offers
    }
}
