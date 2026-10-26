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
    
//    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion: @escaping (Result<[Place], LocationError>) -> Void) {
//
//        var components = URLComponents(string: "https://places-api.foursquare.com/places/search")
//
//
//        components?.queryItems = [
//            URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)"),
//            URLQueryItem(name: "categories", value: "13032,10023,17141"), // coffe shops, atm's, post
//            URLQueryItem(name: "limit", value: "20")
//        ]
//
//        guard let url = components?.url else {
//
//            comletion(.failure(.denied))
//            return }
//
//        let headers = [
//            "Authorization": "Bearer \(apiKey)",
//            "X-Places-Api-Version": "2025-06-17"
//        ]
//        apiClient.request(url: url, headers: headers) { (result: Result<PlaceSearchResponse, ApiError>) in
//            switch result {
//
//            case .success(let respopcs):
//
//                let places = respopcs.results.map(PlaceMapper.map)
//                comletion(.success(places))
//
//            case .failure:
//                comletion(.failure(.denied))
//
//            }
//        }
//
//    }
    
    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion completion: @escaping (Result<[Place], LocationError>) -> Void) {
            // Используем новый рабочий URL
            var components = URLComponents(string: "https://places-api.foursquare.com/places/search")
            
            components?.queryItems = [
                URLQueryItem(name: "ll", value: "\(coordinate.latitude),\(coordinate.longitude)"),
                URLQueryItem(name: "limit", value: "10") // Берем 10 ближайших мест
                // Пока мы убрали категории, чтобы 100% получить ответ на карте.
                // Когда пины появятся, добавим фильтр обратно.
            ]

            guard let url = components?.url else {
                completion(.failure(.denied))
                return
            }

            // Заголовки строго как в успешном curl
            let headers = [
                "Authorization": "Bearer \(apiKey)", // Обязательно слово Bearer и пробел!
                "X-Places-Api-Version": "2025-06-17",
                "Accept": "application/json"
            ]

            print("🌐 ШАГ 3: Репозиторий отправляет запрос в Foursquare...")
            apiClient.request(url: url, headers: headers) { (result: Result<PlaceSearchResponse, ApiError>) in
                switch result {
                case .success(let response):
                    print("✅ ШАГ 4: Репозиторий успешно скачал и распарсил данные!")
                    // Маппинг DTO в Domain модель
                    let places = response.results.map(PlaceMapper.map)
                    completion(.success(places))
                case .failure(let error):
                    print("❌ ОШИБКА ШАГ 4: Репозиторий упал с ошибкой: \(error)")
                    print("🔴 Repository Error: \(error)")
                    completion(.failure(.restricted))
                }
            }
        }
}
