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
        print("▶️ ШАГ 0: Презентер начал запрос локации")
        locationManager.requesrLocation { [weak self] result in
            
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                
                case .failure(let error):
                    self.presenter?.showError("Unable to get location \(error.localizedDescription)")
                    print("❌ ОШИБКА: Презентер не получил локацию: \(error)")
                case .success(let coordinates):
                    print("✅ ШАГ 2: Презентер получил координаты, начинаем загрузку из сети")
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
                    print("🎁 ШАГ 5: Презентер передает \(places.count) мест во View!") 
                    self.presenter?.showPlaces(places)
                    
                }
            }
        }
    }
}
