//
//  UIView+Extensions.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 02/07/22.
//

import Foundation
import UIKit

extension UIView {
    
    func setBorder(width: CGFloat, color: UIColor) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    
}
