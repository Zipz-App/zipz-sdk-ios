//
//  Category.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(Category)
class Category: NSManagedObject, Codable
{
    @NSManaged public var name: String
    @NSManaged public var venues: NSSet?
    
    private enum CodingKeys: String, CodingKey {
        case name
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Category", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Category> {
        return NSFetchRequest<Category>(entityName: "Category")
    }
}
