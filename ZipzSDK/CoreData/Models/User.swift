//
//  User.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 30/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(User)
public class User: NSManagedObject, Codable
{
    // MARK: - Public NSManaged properties
    @NSManaged private var id: Int64
    @NSManaged public var uuid: String
    @NSManaged public var email: String?
    @NSManaged public var name: String?
    @NSManaged public var surname: String?
    @NSManaged public var gender: String?
    @NSManaged public var birthday: Date?
    @NSManaged public var cpf: String?
    @NSManaged public var phone: String?
    var date: String?
    
    private enum CodingKeys: String, CodingKey
    {
        case id = "app_user_id"
        case name = "first_name"
        case surname = "last_name"
        case date = "date_of_birth"
        case uuid, email, gender, cpf, phone
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "User", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        id = try values.decode(Int64.self, forKey: .id)
        uuid = try values.decode(String.self, forKey: .uuid)
        email = try? values.decode(String?.self, forKey: .email)
        name = try? values.decode(String?.self, forKey: .name)
        surname = try? values.decode(String?.self, forKey: .surname)
        gender = try? values.decode(String?.self, forKey: .gender)
        date = try? values.decode(String?.self, forKey: .date)
        cpf = try? values.decode(String?.self, forKey: .cpf)
        phone = try? values.decode(String?.self, forKey: .phone)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone(identifier: "UTC")
        
        if let date = self.date {
            birthday = dateFormatter.date(from: date)
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
}
