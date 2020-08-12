//
//  City.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 10/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(City)
class City: NSManagedObject, Codable
{
    // MARK: - Public NSManaged properties
    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged fileprivate var stateID: Int16
    
    fileprivate var codableState: State?
    
    public var state: State? {
        return State.fetch(with: self.stateID)
    }
        
    private enum CodingKeys: String, CodingKey {
        case id, name
        case codableState = "state"
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "City", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int16.self, forKey: .id)
        name = try values.decode(String.self, forKey: .name)
        codableState = try? values.decode(State?.self, forKey: .codableState)
        
        if let state = codableState {
            State.save(state)
            self.stateID = state.id
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }
    
    static func save(_ new: City)
    {
        if let saved = City.fetch(with: new.id) {
            saved.name = new.name
            saved.stateID = new.stateID
        }
        else {
            context().insert(new)
        }
        ZipzDatabase.saveContext()
    }
}
