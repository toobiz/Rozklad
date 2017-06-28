//
//  Station.swift
//  Rozklad
//
//  Created by Michał Tubis on 29.06.2017.
//  Copyright © 2017 Mike Tubis. All rights reserved.
//

import Foundation
import CoreData

@objc(Station)
class Station: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var name_slug: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var hits: NSNumber
    @NSManaged var ibnr: NSNumber
    
    override init(entity: NSEntityDescription, insertInto context: NSManagedObjectContext?) {
        super.init(entity: entity, insertInto: context)
    }
    
    init(dictionary: [String: AnyObject], context: NSManagedObjectContext) {
        let entity =  NSEntityDescription.entity(forEntityName: "Quiz", in: context)!
        super.init(entity: entity, insertInto: context)
        
        if let station_id = dictionary["id"] {
            id = station_id as! NSNumber
        }
        
        if let station_name = dictionary["name"] {
            name = station_name as! String
        }
        
        if let station_name_slug = dictionary["name_slug"] {
            name_slug = station_name_slug as! String
        }
        
        if let station_latitude = dictionary["latitude"] {
            latitude = station_latitude as! Double
        }
        
        if let station_longitude = dictionary["longitude"] {
            longitude = station_longitude as! Double
        }
        
        if let stations_hits = dictionary["hits"] {
            hits = stations_hits as! NSNumber
        }
        
        if let station_ibnr = dictionary["ibnr"] {
            ibnr = station_ibnr as! NSNumber
        }
    }
}
