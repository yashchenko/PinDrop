//
//  LocationError.swift
//  PinDrop
//
//  Created by Ivan on 21.09.2026.
//

import Foundation

enum LocationError: Error {
    case denied
    case restricted
    case notDetermined
    case unknown
}
