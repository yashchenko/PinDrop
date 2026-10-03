//
//  PlaceMapper.swift
//  PinDrop
//
//  Created by Ivan on 28.09.2026.
//

import CoreLocation

enum PlaceMapper {
    
    static func map(_ dto: PlaceModel) -> Place {
        
        Place(id: dto.fsqPlaceId, name: dto.name, category: dto.categories.first?.name ?? "Unknown", coordinates: CLLocationCoordinate2D(latitude: dto.latitude, longitude: dto.longitude), address: dto.location?.formattedAddress ?? dto.location?.address)
    }
    
}
