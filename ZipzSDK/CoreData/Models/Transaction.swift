//
//  Transaction.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 11/06/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import Foundation
import CoreData

@objc(Transaction)
public class Transaction: NSManagedObject, Codable
{
    @NSManaged public var uuid: String
    @NSManaged private var venueID: String
    @NSManaged private var offerID: String
    @NSManaged public var expirationDate: Date?
    @NSManaged public var reddemedDate: Date?
    @NSManaged public var staffName: String?
    @NSManaged public var qrValue: String?
    
    private var staff: Staff?
    private var qrcard: QRCard?
    private var expirationTime: String?
    private var redeemedAt: String?
    private var codableVenue: Venue?
    private var codableOffer: Offer?
    
    public var venue:Venue? {
        return Venue.fetch(with: self.venueID)
    }
    
    public var offer:Offer? {
        return Offer.fetch(with: self.offerID)
    }
    
    private enum CodingKeys: String, CodingKey
    {
        case uuid, staff
        case codableOffer = "offer"
        case codableVenue = "venue"
        case qrcard = "qr_card"
        case expirationTime = "expiration_time"
        case redeemedAt = "redeemed_at"
    }
    
    public func encode(to encoder: Encoder) throws {
        var _ = encoder.container(keyedBy: CodingKeys.self)
    }
    
    // Crucial method for merging Codable and NSManagedObject
    required convenience public init(from decoder: Decoder) throws
    {
        // Create NSEntityDescription with NSManagedObjectContext
        let context = ZipzDatabase.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Transaction", in: context)
        self.init(entity: entity!, insertInto: nil)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        uuid = try values.decode(String.self, forKey: .uuid)
        codableVenue = try? values.decode(Venue?.self, forKey: .codableVenue)
        codableOffer = try? values.decode(Offer?.self, forKey: .codableOffer)
        staff = try? values.decode(Staff?.self, forKey: .staff)
        qrcard = try? values.decode(QRCard?.self, forKey: .qrcard)
        expirationTime = try? values.decode(String?.self, forKey: .expirationTime)
        redeemedAt = try? values.decode(String?.self, forKey: .redeemedAt)
        
        
        if let staff = staff {
            staffName = staff.name
        }
        if let qrcard = qrcard {
            qrValue = qrcard.name
        }
        
        if let venue = codableVenue {
            Venue.save(venue)
            self.venueID = venue.uuid
        }
        
        if let offer = codableOffer {
            Offer.save(offer)
            self.offerID = offer.uuid
        }
    }
    
    // MARK: - NSFetchRequest
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Transaction> {
        return NSFetchRequest<Transaction>(entityName: "Transaction")
    }
    
    static func save(_ new: Transaction)
    {
        if let saved = Transaction.fetch(with: new.uuid)
        {
            saved.expirationDate = new.expirationDate
            saved.reddemedDate = new.reddemedDate
            saved.qrValue = new.qrValue
            saved.staffName = new.staffName
            saved.venueID = new.venueID
            saved.offerID = new.offerID
        }
        else {
            context().insert(new)
        }
        
        ZipzDatabase.saveContext()
    }
}
