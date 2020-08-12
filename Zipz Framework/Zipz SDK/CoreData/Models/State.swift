//
//  State.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 09/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(State)
class State: NSManagedObject, Codable
{
    // MARK: - Public NSManaged properties
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id, name
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "State", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int16.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<State> {
        return NSFetchRequest<State>(entityName: "State")
    }
}
