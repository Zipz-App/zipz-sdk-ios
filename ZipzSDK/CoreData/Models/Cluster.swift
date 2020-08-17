//
//  Cluster.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(Cluster)
public class Cluster: NSManagedObject, Codable
{    
    // MARK: - Public NSManaged properties
    @NSManaged public var uuid: String
    @NSManaged public var type: String
    @NSManaged public var name: String
    @NSManaged public var info: String?
    @NSManaged public var address: String?
    @NSManaged public var number: String?
    @NSManaged private var cityID: Int16
    @NSManaged public var image: Data?
    @NSManaged public var neighborhood: String?
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var order: Int16
    @NSManaged private var venueIDs: [String]?
    
    fileprivate var codableCity: City?
    fileprivate var codableVenues: [Venue]?
    fileprivate var latitudeString: String?
    fileprivate var longitudeString: String?
    fileprivate var imageURL: String?
    fileprivate var orderNumber: Int16?
    
    public var venues: [Venue]?
    {
        var holder: [Venue]?
        self.venueIDs?.forEach({ index in
            if let venue = Venue.fetch(with: index) {
                holder?.append(venue)
            }
        })
        return holder
    }
    
    public var city:City? {
        return City.fetch(with: self.cityID)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case uuid, type, name, address
        case info = "description"
        case orderNumber = "order"
        case latitudeString = "latitude"
        case longitudeString = "longitude"
        case imageURL = "image"
        case number = "street_number"
        case neighborhood
        case codableVenues = "venues"
        case codableCity = "city"
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Cluster", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        type = try values.decode(String.self, forKey: .type)
        name = try values.decode(String.self, forKey: .name)
        info = try? values.decode(String?.self, forKey: .info)
        address = try? values.decode(String?.self, forKey: .address)
        number = try? values.decode(String?.self, forKey: .number)
        codableCity = try? values.decode(City?.self, forKey: .codableCity)
        imageURL = try? values.decode(String.self, forKey: .imageURL)
        neighborhood = try? values.decode(String.self, forKey: .neighborhood)
        latitudeString = try? values.decode(String.self, forKey: .latitudeString)
        longitudeString = try? values.decode(String.self, forKey: .longitudeString)
        orderNumber = try? values.decode(Int16.self, forKey: .orderNumber)
        codableVenues = try? values.decode([Venue]?.self, forKey: .codableVenues)
        
        if let latitudeString = latitudeString {
            latitude = Double(latitudeString)!
        }
        
        if let longitudeString = longitudeString {
            longitude = Double(longitudeString)!
        }
        
        if let imageURL = imageURL
        {
            let url = URL(string: imageURL)!
            if let data = try? Data(contentsOf: url) {
                image = data
            }
        }
        
        if let orderNumber = orderNumber {
            order = orderNumber
        }
        
        if let venues = codableVenues {
            venues.forEach { venue in
                Venue.save(venue)
                self.venueIDs?.append(venue.uuid)
            }
        }
        
        if let city = codableCity {
            City.save(city)
            self.cityID = city.id
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Cluster> {
        return NSFetchRequest<Cluster>(entityName: "Cluster")
    }
    
    static func save(_ new: Cluster)
    {
        if let saved = Cluster.fetch(with: new.uuid)
        {
            saved.type = new.type
            saved.name = new.name
            saved.info = new.info
            saved.number = new.number
            saved.address = new.address
            saved.image = new.image
            saved.neighborhood = new.neighborhood
            saved.latitude = new.latitude
            saved.longitude = new.longitude
            saved.venueIDs = new.venueIDs
            saved.cityID = new.cityID
        }
        else {
            context().insert(new)
        }
        
        ZipzDatabase.saveContext()
    }
}
