//
//  Venue.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(Venue)
public class Venue: NSManagedObject, Codable
{
    // MARK: - Public NSManaged properties
    @NSManaged public var uuid: String
    @NSManaged public var name: String
    @NSManaged public var sufix: String
    @NSManaged public var info: String?
    @NSManaged public var image: Data?
    @NSManaged public var categories: [String]?
    @NSManaged public var address: String
    @NSManaged public var number: String
    @NSManaged public var neighborhood: String?
    @NSManaged private var cityID: Int16
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var mon: String?
    @NSManaged public var tue: String?
    @NSManaged public var wed: String?
    @NSManaged public var thu: String?
    @NSManaged public var fri: String?
    @NSManaged public var sat: String?
    @NSManaged public var sun: String?
    
    private var latitudeString: String?
    private var longitudeString: String?
    private var imageURL: String?
    private var hours: Hours?
    private var codableCity: City?
    private var codableCategories: [Category]?
    
    public var city:City? {
        return City.fetch(with: self.cityID)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case uuid, name, address, hours
        case codableCategories = "category"
        case codableCity = "city"
        case neighborhood
        case latitudeString = "latitude"
        case longitudeString = "longitude"
        case imageURL = "image"
        case sufix = "name_2"
        case number = "street_number"
        case info = "description"
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Venue", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        name = try values.decode(String.self, forKey: .name)
        info = try? values.decode(String.self, forKey: .info)
        address = try values.decode(String.self, forKey: .address)
        number = try values.decode(String.self, forKey: .number)
        neighborhood = try? values.decode(String?.self, forKey: .neighborhood)
        codableCategories = try? values.decode([Category]?.self, forKey: .codableCategories)
        codableCity = try values.decode(City?.self, forKey: .codableCity)
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        latitudeString = try? values.decode(String.self, forKey: .latitudeString)
        longitudeString = try? values.decode(String.self, forKey: .longitudeString)
        hours = try? values.decode(Hours.self, forKey: .hours)
        
        if let imageURL = imageURL
        {
            let url = URL(string: imageURL)!
            if let data = try? Data(contentsOf: url) {
                image = data
            }
        }
        
        if let hours = self.hours
        {
            mon = hours.mon
            tue = hours.tue
            wed = hours.wed
            thu = hours.thu
            fri = hours.fri
            sat = hours.sat
            sun = hours.sun
        }
        
        if let city = codableCity {
            City.save(city)
            self.cityID = city.id
        }
        
        if let category = codableCategories {
            categories = []
            category.forEach { category in
                Category.save(category)
                categories?.append(category.name)
            }
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Venue> {
        return NSFetchRequest<Venue>(entityName: "Venue")
    }
    
    static func save(_ new: Venue)
    {
        if let saved = Venue.fetch(with: new.uuid) {
            saved.name = new.name
            saved.sufix = new.sufix
            saved.info = new.info
            saved.image = new.image
            saved.address = new.address
            saved.number = new.number
            saved.latitude = new.latitude
            saved.longitude = new.longitude
            saved.hours = new.hours
            saved.cityID = new.cityID
            saved.categories = new.categories
            saved.mon = new.mon
            saved.tue = new.tue
            saved.wed = new.wed
            saved.thu = new.thu
            saved.fri = new.fri
            saved.sat = new.sat
            saved.sun = new.sun
        }
        else {
            context().insert(new)
        }
        ZipzDatabase.saveContext()
    }
}
