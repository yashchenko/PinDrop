//
//  CoreLocationManager.swift
//  PinDrop
//
//  Created by Ivan on 21.09.2026.
//

import CoreLocation

class CoreLocationManager: NSObject, LocationManagerProtocol {
    
    private let manager = CLLocationManager()
    
    private var completion: ((Result<CLLocationCoordinate2D, LocationError>) -> Void)?
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    func requesrLocation(compltion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void) {
        self.completion = compltion
        
        let status = manager.authorizationStatus
        
        switch status {
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse, .authorizedAlways:
            manager.requestLocation()
        case .denied:
            compltion(.failure(.denied))
        case .restricted:
            compltion(.failure(.restricted))
        @unknown default:
            compltion(.failure(LocationError.unknown))
            self.completion = nil
        }
    }
}

extension CoreLocationManager: CLLocationManagerDelegate {
    
    // when user press allow or denied
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            
            manager.requestLocation()
        } else if status == .denied || status == .restricted {
            
            completion?(.failure(.denied))
            self.completion = nil
        }
    }
    
    // success: we get coordinates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.last else { return }
        print("📍 ШАГ 1: CoreLocation успешно получил координаты: \(location.coordinate)")
        completion?(.success(location.coordinate))
        self.completion = nil // we release the closure to avoid memory leaks
    }
    
    // gps unavailable, etc
    
    // Ошибка: GPS недоступен и т.д.
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            
            if let clError = error as? CLError {
                // ВАЖНО: Игнорируем временную ошибку симулятора
                if clError.code == .locationUnknown {
                    print("⚠️ CoreLocation: Симулятор ищет спутники, ждем...")
                    return
                }
                
                if clError.code == .denied {
                    completion?(.failure(.denied))
                } else {
                    completion?(.failure(.unknown))
                }
            } else {
                completion?(.failure(.unknown))
            }
            
            // Уничтожаем замыкание только если это реальная фатальная ошибка
            self.completion = nil
        }
    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//
//        if let clError = error as? CLError, clError.code == .denied {
//
//            completion?(.failure(.denied))
//
//        } else {
//
//            completion?(.failure(.unknown))
//        }
//
//        self.completion = nil
//    }
}
