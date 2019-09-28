//
//  UIViewExtension.swift
//  eKar
//
//  Created by Arya Menon K on 9/28/19.
//  Copyright © 2019 Arya. All rights reserved.
//

import UIKit

extension UIView {
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }

    func setBorder(color: CGColor = UIColor.lightGray.cgColor,width: CGFloat = 1) {
        // set border for view
        layer.borderColor = color
        layer.borderWidth = width
    }
    
    func setCornerRaduis(radius: CGFloat = 3) {
        // set round corner for view
        layer.cornerRadius = radius
        clipsToBounds = true
    }
}
