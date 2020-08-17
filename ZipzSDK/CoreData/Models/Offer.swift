//
//  Offer.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(Offer)
public class Offer: NSManagedObject, Codable
{
    @NSManaged public var uuid: String
    @NSManaged public var name: String
    @NSManaged public var info: String?
    @NSManaged public var image: Data?
    @NSManaged public var status: String
    @NSManaged public var gender: String
    @NSManaged public var quantity: String
    @NSManaged public var expiration: Int16
    @NSManaged public var offerPrice: Double
    @NSManaged public var fullPrice: Double
    @NSManaged public var categories: [String]?
    
    private var imageURL: String?
    private var codableCategories: [Category]?
    
    private enum CodingKeys: String, CodingKey
    {
        case uuid, name, status, quantity, gender
        case info = "description"
        case imageURL = "image"
        case codableCategories = "category"
        case expiration = "expiration_period"
        case offerPrice = "offer_price"
        case fullPrice = "full_price"
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Offer", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        name = try values.decode(String.self, forKey: .name)
        info = try? values.decode(String?.self, forKey: .info)
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        status = try values.decode(String.self, forKey: .status)
        quantity = try values.decode(String.self, forKey: .quantity)
        gender = try values.decode(String.self, forKey: .gender)
        expiration = try values.decode(Int16.self, forKey: .expiration)
        offerPrice = try values.decode(Double.self, forKey: .offerPrice)
        fullPrice = try values.decode(Double.self, forKey: .fullPrice)
        codableCategories = try? values.decode([Category]?.self, forKey: .codableCategories)
        
        if let imageURL = imageURL
        {
            let url = URL(string: imageURL)!
            if let data = try? Data(contentsOf: url) {
                image = data
            }
        }
        
        if let categories = codableCategories {
            self.categories = []
            categories.forEach { category in
                Category.save(category)
                self.categories?.append(category.name)
            }
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Offer> {
        return NSFetchRequest<Offer>(entityName: "Offer")
    }
}
