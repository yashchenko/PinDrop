//
//  PlaceDetailVC.swift
//  PinDrop
//
//  Created by Ivan on 08.10.2026.
//

import UIKit

class PlaceCardVC: UIViewController {
    
    
    private let place: Place
    
    private var containerBottomConstraint: NSLayoutConstraint!
    
    // MARK: - UI
    
    // just dim the map
    private let dimmingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.alpha = 0 // Изначально прозрачный
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
        
    }()
    
    // card itself
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        view.layer.cornerRadius = 24
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // Скругляем только верх
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // category
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark.circle.fill"), for: .normal)
        button.tintColor = .tertiaryLabel
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    init(place: Place) {
        self.place = place
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .overFullScreen
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupData()
        setupUI()
        setupGestures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        animateShow()
        
        
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        
        view.backgroundColor = .clear
        
        view.addSubviews(views: [dimmingView, containerView])
        containerView.addSubviews(views: [titleLabel, categoryLabel, closeButton])
        
        let cardHeight: CGFloat = 300
        
        // constraint for animation
        
        containerBottomConstraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: cardHeight)
        
        NSLayoutConstraint.activate([
            // Фон на весь экран
            dimmingView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            dimmingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            // Карточка
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.heightAnchor.constraint(equalToConstant: cardHeight),
            containerBottomConstraint, // Наш динамический констрейнт
            
            // Заголовок
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: closeButton.leadingAnchor, constant: -16),
            
            // Категория
            categoryLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            categoryLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 24),
            categoryLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            
            // Кнопка закрытия
            closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 24),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -24),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func setupData() {
        
        titleLabel.text = place.name
        categoryLabel.text = place.category
    }
    
    private func setupGestures() {
        
        // close with X button
        closeButton.addTarget(self, action: #selector(animateHideAndDismiss), for: .touchUpInside)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(animateHideAndDismiss))
        dimmingView.addGestureRecognizer(tapGesture)
        
    }
    
    // MARK: - Animations
    
    private func animateShow() {
        
        containerBottomConstraint.constant = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
            self.dimmingView.alpha = 1
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func animateHideAndDismiss() {
        
        // taking away down
        containerBottomConstraint.constant = 300
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
            self.dimmingView.alpha = 0
            self.view.layoutIfNeeded()
        } completion: { _ in
            
            // when animation is end - killing the controller
            self.dismiss(animated: false)
        }

    }
}
