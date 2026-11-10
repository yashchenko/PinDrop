//
//  File.swift
//  PinDrop
//
//  Created by Ivan on 03.10.2026.
//

import CoreLocation
import MapKit

protocol MapViewProtocol: AnyObject {
    
    func showUserLocation(_ coordinate: CLLocationCoordinate2D)
    
    func showPlaces(_ place: [Place])
    
    func showError(_ error: String)
    
    func searchQuerySuggestions(_ places: [Place])
    
    func focusOnPlace(_ coordinate: CLLocationCoordinate2D)
    
    func drawRoute(_ polyline: MKPolyline)
}
