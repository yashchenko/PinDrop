//
//  PlaceRepositoryProtocol.swift
//  PinDrop
//
//  Created by Ivan on 26.09.2026.
//

import CoreLocation
import MapKit

protocol PlaceRepositoryProtocol {
    
    func fetchNearByPlaces(coordinate: CLLocationCoordinate2D, comletion: @escaping (Result<[Place], LocationError>) -> Void)
    
    func saveFavourite(_ place: Place, completion: @escaping (Result<Void, Error>) -> Void)
    
    func deleteFavourite(id: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    func fetchFavourites(completion: @escaping (Result<[Place], Error>) -> Void)
    
    func searchPlaces(query: String, coordinate: CLLocationCoordinate2D, completion: @escaping (Result<[Place], LocationError>) -> Void)
    
    func fetchPlaceSetails(id: String, copletion: @escaping (Result<Place, LocationError>) -> Void)
    
    func calculateRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D, completion: @escaping (Result<MKPolyline, Error>) -> Void)
}
