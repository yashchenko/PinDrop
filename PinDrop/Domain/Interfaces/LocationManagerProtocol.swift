//
//  LocationManagerProtocol.swift
//  PinDrop
//
//  Created by Ivan on 21.09.2026.
//

import CoreLocation

protocol LocationManagerProtocol {
    
    func requesrLocation(compltion: @escaping (Result<CLLocationCoordinate2D, LocationError>) -> Void)
}
