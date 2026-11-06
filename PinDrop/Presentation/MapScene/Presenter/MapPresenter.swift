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
    private var favouriteIDs: Set<String> = []
    
    private var userCoordinate: CLLocationCoordinate2D?
    private var searchWorkItem: DispatchWorkItem?
    
    init(location: LocationManagerProtocol, placeRepo: PlaceRepositoryProtocol) {
        self.locationManager = location
        self.placeRepo = placeRepo
    }
    
    func viewDidLoad() {
        
        loadFavourites()
        requestLocationAndFetchesPlaces()
    }
    
    func isFavourite(_ place: Place) -> Bool {
        
        return favouriteIDs.contains(place.id)
        
    }
    
    func toggleFavourite(place: Place) {
        
        if isFavourite(place) {
            
            placeRepo.deleteFavourite(id: place.id) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {
                
                case .failure(let error):
                    
                    self.presenter?.showError(error.localizedDescription)
                    
                case .success(()):
                    
                    self.favouriteIDs.remove(place.id)
                
                }
        
            }
        } else {
            
            
            self.placeRepo.saveFavourite(place) { [weak self] result in
                
                guard let self = self else { return }
                
                switch result {

                case .failure(let error):
                    
                    self.presenter?.showError(error.localizedDescription)


                case .success(()):

                    self.favouriteIDs.insert(place.id)
                    
                print("toggle fav success")
                    
                }
            }
    
        }
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
                    self.userCoordinate = coordinates
                    
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
    
    
    private func loadFavourites() {
        
        placeRepo.fetchFavourites { [weak self] resukt in
            guard let self = self else { return }
                
                switch resukt {
                
                case .failure(let error):
                    print(error.localizedDescription)
                
                case .success(let places):
                
                    let iDs = places.map { place -> String in
                        return place.id
                    }
                    
                    self.favouriteIDs = Set(iDs)
                }
                
            }
        }
    
    func searchQueryChanged(_ query: String) {
        searchWorkItem?.cancel()
        
        let trimmedQuery = query.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedQuery.isEmpty, let coordinate = userCoordinate else {
            
            presenter?.searchQuerySuggestions([])
            
            return
        }
        
        let workingItem = DispatchWorkItem { [weak self] in
            
            guard let self = self else { return }
            
            self.placeRepo.searchPlaces(query: trimmedQuery, coordinate: coordinate) { result in
                
                
                DispatchQueue.main.async {
                    
                    switch result {
                    
                    case .failure(let error):
                        
                        self.presenter?.showError(error.localizedDescription)
                        
                    case .success(let places):
                        self.presenter?.searchQuerySuggestions(places)
                    
                    }
                }
            }
        }
        
        searchWorkItem = workingItem
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workingItem)
    }
}
