//
//  PlaceRepository.swift
//  PinDrop
//
//  Created by Ivan on 01.10.2026.
//

import CoreLocation

final class PlaceRepository: PlaceRepositoryProtocol {
    
    private let apiClient: ApiClientProtocol
    private let apiKey: String
    
    init(api: ApiClientProtocol, apiKey: String) {
        self.apiClient = api
        self.apiKey = apiKey
    }
    
    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion: @escaping (Result<[Place], LocationError>) -> Void) {
        
        var components = URLComponents(string: "https://places-api.foursquare.com/places/search")
        
        
        components?.queryItems = [
            URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)"),
            URLQueryItem(name: "categories", value: "13032,10023,17141"), // coffe shops, atm's, post
            URLQueryItem(name: "limit", value: "20")
        ]
        
        guard let url = components?.url else {
            
            comletion(.failure(.denied))
            return }
        
        let headers = [
            "Authorization": "Bearer \(apiKey)",
            "X-Places-Api-Version": "2025-06-17"
        ]
        apiClient.request(url: url, headers: headers) { (result: Result<PlaceSearchResponse, ApiError>) in
            switch result {
            
            case .success(let respopcs):
                
                let places = respopcs.results.map(PlaceMapper.map)
                comletion(.success(places))
                
            case .failure:
                comletion(.failure(.denied))
                
            }
        }
        
    }
}
