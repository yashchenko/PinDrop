//
//  FavouritePlaceEntity.swift
//  PinDrop
//
//  Created by Ivan on 17.10.2026.
//

import CoreLocation
import CoreData

@objc(FavouritePlaceEntity)

final class FavouritePlaceEntity: NSManagedObject {
    
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var category: String
    @NSManaged var latitude: Double
    @NSManaged var longitude: Double
    @NSManaged var address: String?
}

extension FavouritePlaceEntity {
    
    static var entityName: String {
        
        "FavouritePlace"
        
    }
    
    @nonobjc class func fetchRequest() -> NSFetchRequest<FavouritePlaceEntity> {
        return NSFetchRequest<FavouritePlaceEntity>(entityName: entityName)
    }
    
    func populate(from place: Place) {
        
        self.id = place.id
        self.name = place.name
        self.category = place.category
        self.latitude = place.coordinates.latitude
        self.longitude = place.coordinates.longitude
        self.address = place.address
        
    }
    
    func toDomain() -> Place {
        return Place(id: id, name: name, category: category, coordinates: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), address: address)
    }
}
