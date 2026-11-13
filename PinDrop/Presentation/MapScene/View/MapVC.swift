//
//  MapVC.swift
//  PinDrop
//
//  Created by Ivan on 05.10.2026.
//

import UIKit
import MapKit

final class MapVC: UIViewController {

    // MARK: - Properties
    
    private let customView = MapView()
    private let presenter: MapPresenter
    
    var places: [Place] = []
    
    var suggestedPlaces: [Place] = []
    
    
    // MARK: - Init
    
    init(presenter: MapPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        presenter.viewDidLoad()
        setupActions()
        customView.mapKitView.delegate = self
        customView.searchTextField.delegate = self
        customView.suggestionsTableView.delegate = self
        customView.suggestionsTableView.dataSource = self
        customView.suggestionsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "SuggestionCell")
        
        
    }

    // MARK: - Methods
    
    private func setupActions() {
        
        customView.locationButton.addTarget(self, action: #selector(centerMapOnUser), for: .touchUpInside)
        
        customView.searchTextField.addTarget(self, action: #selector(searchTextChanged), for: .editingChanged)
        
        customView.favouriresButton.addTarget(self, action: #selector(didTapFavourites), for: .touchUpInside)
    }
    
    @objc func centerMapOnUser() {
        
        guard let location = customView.mapKitView.userLocation.location else { return }
        
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        customView.mapKitView.setRegion(region, animated: true)
        
    }
    
    @objc func searchTextChanged(_ textField: UITextField) {
        
        presenter.searchQueryChanged(textField.text ?? "")
    }
    
    @objc func didTapFavourites() {
        
        customView.mapKitView.removeOverlays(customView.mapKitView.overlays)
        presenter.toggleFavouritesFilter()
    }
}


extension MapVC: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        mapView.deselectAnnotation(view.annotation, animated: true)
        
        guard let annotation = view.annotation, let id = annotation.subtitle else { return }
        
        guard let place = self.places.first(where: { place -> Bool in
            place.id == id
        }) else { return }
        
        let detailVC = PlaceCardVC(place: place, isFavourite: presenter.isFavourite(place), distance: presenter.formattedDistance(to: place))
        detailVC.didFavouriteTapped = { [weak self] in
            
            self?.presenter.toggleFavourite(place: place)
            
        }
        
        detailVC.didDirectionTapped = { [weak self] in
            
            self?.presenter.requestRoute(to: place)
            
        }
        
        present(detailVC, animated: true)
        
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if let polyline = overlay as? MKPolyline {
            let render = MKPolylineRenderer(polyline: polyline)
            render.strokeColor = .systemBlue
            render.lineWidth = 5
            return render
        }
        
        return MKOverlayRenderer(overlay: overlay)
        
    }
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
    
    func searchQuerySuggestions(_ places: [Place]) {
        
        self.suggestedPlaces = places
        customView.suggestionsTableView.isHidden = places.isEmpty
        customView.suggestionsTableView.reloadData()
        
    }
    
    func focusOnPlace(_ coordinate: CLLocationCoordinate2D) {
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 300, longitudinalMeters: 300)
        customView.mapKitView.setRegion(region, animated: true)
    }
    
    func drawRoute(_ polyline: MKPolyline) {
        customView.mapKitView.removeOverlays(customView.mapKitView.overlays)
        customView.mapKitView.addOverlay(polyline)
        
        let edgePaddings = UIEdgeInsets(top: 100, left: 40, bottom: 60, right: 40)
        customView.mapKitView.setVisibleMapRect(polyline.boundingMapRect, edgePadding: edgePaddings, animated: true)
        
    }
    
    func updateFavouritesFilterState(isActive: Bool) {
        let iconView = isActive ? "heart.fill" : "heart"
        
        customView.favouriresButton.setImage(UIImage(systemName: iconView), for: .normal)
        customView.favouriresButton.tintColor = isActive ? .systemRed : .secondaryLabel
        
    }
    
    
}


extension MapVC: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
     
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return suggestedPlaces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        
        let place = suggestedPlaces[indexPath.row]
        
        cell.textLabel?.text = "\(place.name)•\(place.category)"
        
        cell.textLabel?.font = .systemFont(ofSize: 14)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let selectedPlace = suggestedPlaces[indexPath.row]
        
        customView.suggestionsTableView.isHidden = true
        customView.searchTextField.text = selectedPlace.name
        customView.searchTextField.resignFirstResponder()
        
        showPlaces([selectedPlace])
        
        showUserLocation(selectedPlace.coordinates)
        
//        let detailVC = PlaceCardVC(place: selectedPlace, isFavourite: presenter.isFavourite(selectedPlace))
//        detailVC.didFavouriteTapped = { [weak self] in
//
//            self?.presenter.toggleFavourite(place: selectedPlace)
//
//        }
//
//        present(detailVC, animated: true)
        
        presenter.didSelectSearchSuggestion(selectedPlace)
        
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        
        customView.mapKitView.removeOverlays(customView.mapKitView.overlays)
        
        suggestedPlaces = []
        customView.suggestionsTableView.isHidden = true
        customView.suggestionsTableView.reloadData()
        return true
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        suggestedPlaces = []
        
        customView.mapKitView.removeOverlays(customView.mapKitView.overlays)
        
       // textField.resignFirstResponder()
        customView.suggestionsTableView.isHidden = true
        customView.suggestionsTableView.reloadData()
        presenter.didClearSearch()
        return true
        
        
    }
    
}
