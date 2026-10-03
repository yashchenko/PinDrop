//
//  PlaceModel.swift
//  PinDrop
//
//  Created by Ivan on 26.09.2026.
//

import CoreLocation

struct PlaceSearchResponse: Decodable {
    let results: [PlaceModel]
    
}

struct PlaceModel: Decodable {
    
    let fsqPlaceId: String
    let name: String
    let latitude: Double
    let longitude: Double
    let categories: [Category]
    let location: Location?
    
    
    enum CodingKeys: String, CodingKey {
        case fsqPlaceId = "fsq_place_id"
        case name, latitude, longitude, categories, location
    }
    
}


struct Category: Decodable {
    let fsqCategoryId: String
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case fsqCategoryId = "fsq_category_id"
        case name
    }
}

struct Location: Decodable {
    let address: String?
    let locality: String?
    let region: String?
    let postcode: String?
    let country: String?
    let formattedAddress: String?
    
    enum CodingKeys: String, CodingKey {
        case address, locality, region, postcode, country
        case formattedAddress = "formatted_address"
    }
}
