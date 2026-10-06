//
//  File.swift
//  PinDrop
//
//  Created by Ivan on 03.10.2026.
//

import CoreLocation

protocol MapViewProtocol: AnyObject {
    
    func showUserLocation(_ coordinate: CLLocationCoordinate2D)
    
    func showPlaces(_ place: [Place])
    
    func showError(_ error: String)
}
