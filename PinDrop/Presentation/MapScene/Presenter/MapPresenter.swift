//
//  MapPresenter.swift
//  PinDrop
//
//  Created by Ivan on 03.10.2026.
//

import CoreLocation

final class MapPresenter {
    
    weak var presenter: MapViewProtocol?
    
    private let locationManager: LocationManagerProtocol
    private let placeRepo: PlaceRepositoryProtocol
    
    init(location: LocationManagerProtocol, placeRepo: PlaceRepositoryProtocol) {
        self.locationManager = location
        self.placeRepo = placeRepo
    }
    
    func viewDidLoad() {
        
        requestLocationAndFetchesPlaces()
    }
    
    func requestLocationAndFetchesPlaces() {
        locationManager.requesrLocation { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                
                case .failure(let error):
                    self.presenter?.showError("Unable to get location \(error.localizedDescription)")
                case .success(let coordinates):
                    self.presenter?.showUserLocation(coordinates)
                    self.fetchPlaces(for: coordinates)
                    
                }
            }
            
        }
    }
    
    
    private func fetchPlaces(for coordinate: CLLocationCoordinate2D) {
        
        placeRepo.fetchNearByPlaces(coordinate: coordinate) { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                
                case .failure(let error):
                    self.presenter?.showError(error.localizedDescription)
                
                case .success(let places):
                    self.presenter?.showPlaces(places)
                }
            }
        }
    }
}
