//
//  MapVC.swift
//  PinDrop
//
//  Created by Ivan on 05.10.2026.
//

import UIKit
import MapKit

final class MapVC: UIViewController {

    private let customView = MapView()
    private let presenter: MapPresenter
    
    private var places: [Place] = []
    
    init(presenter: MapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupActions()
        customView.mapKitView.delegate = self
    }

    
    private func setupActions() {
        
        customView.locationButton.addTarget(self, action: #selector(centerMapOnUser), for: .touchUpInside)
    }
    
    @objc func centerMapOnUser() {
        
        guard let location = customView.mapKitView.userLocation.location else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        customView.mapKitView.setRegion(region, animated: true)
        
    }
}


extension MapVC: MKMapViewDelegate {
    
    // In the future, we will be tracking a click on the pin to open the Bottom Sheet (ticket MAR-209)
    
}

extension MapVC: MapViewProtocol {
    func showUserLocation(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        customView.mapKitView.setRegion(region, animated: true)
        
    }
    
    func showPlaces(_ place: [Place]) {
        self.places = place
        
        let oldAnnotation = customView.mapKitView.annotations.filter { annotaion -> Bool in
            !(annotaion is MKUserLocation)
        }
        
        customView.mapKitView.removeAnnotations(oldAnnotation)
        
        for place in places {
            let annottion = MKPointAnnotation()
            annottion.coordinate = place.coordinates
            annottion.title = place.name
            annottion.subtitle = place.id
            customView.mapKitView.addAnnotation(annottion)
            
        }
    }
        
    func showError(_ error: String) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "what can I done", style: .default, handler: { _ in
            print("MapVC alert error action")
        }))
        present(alert, animated: true) {
            print("alert is showing")
        }
    }
    
    
    
}
