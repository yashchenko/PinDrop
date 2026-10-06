//
//  UIView+Ext.swift
//  PinDrop
//
//  Created by Ivan on 05.10.2026.
//

import UIKit

extension UIView {
    
    func addSubviews(views: [UIView]) {
        
        views.forEach { child in
            addSubview(child)
        }
        
    }
}
