//
//  MapVC.swift
//  PinDrop
//
//  Created by Ivan on 05.10.2026.
//

import UIKit
import MapKit

final class MapView: UIView {
    
    let mapKitView: MKMapView = {
        
        let map = MKMapView()
        map.showsUserLocation = true // blue dot showing where user
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()
    
    // location to center button
    let locationButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "location.fill"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .systemBlue
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let searchBarContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 16
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = CGSize(width: 0, height: 2)
        view.layer.shadowRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search places..."
        textField.font = .systemFont(ofSize: 15)
        textField.clearButtonMode = .whileEditing
        textField.returnKeyType = .search
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    let suggestionsTableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.isHidden = true
        table.layer.cornerRadius = 16
        table.tableFooterView = UIView()
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    let favouriresButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.backgroundColor = .systemBackground
        button.tintColor = .secondaryLabel
        button.layer.cornerRadius = 25
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.2
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowRadius = 4
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        
        let arrayViews = [mapKitView, locationButton, searchBarContainer, suggestionsTableView, favouriresButton]
        searchBarContainer.addSubview(searchTextField)
        addSubviews(views: arrayViews)
        
        NSLayoutConstraint.activate([
            // ignoring safe area
            mapKitView.topAnchor.constraint(equalTo: topAnchor),
            mapKitView.bottomAnchor.constraint(equalTo: bottomAnchor),
            mapKitView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mapKitView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            searchBarContainer.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            searchBarContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchBarContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 50),
            
            searchTextField.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor, constant: 16),
            searchTextField.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -16),
            searchTextField.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
            
            suggestionsTableView.topAnchor.constraint(equalTo: searchBarContainer.bottomAnchor, constant: 8),
            suggestionsTableView.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            suggestionsTableView.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            suggestionsTableView.heightAnchor.constraint(equalToConstant: 220),
            
            // button (50x50)
            locationButton.widthAnchor.constraint(equalToConstant: 50),
            locationButton.heightAnchor.constraint(equalToConstant: 50),
            locationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            locationButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -32),
            
            favouriresButton.widthAnchor.constraint(equalToConstant: 50),
            favouriresButton.heightAnchor.constraint(equalToConstant: 50),
            favouriresButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24),
            favouriresButton.bottomAnchor.constraint(equalTo: locationButton.topAnchor, constant: -16)
        ])
    }
}
