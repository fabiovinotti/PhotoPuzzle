//
//  UIImage+Extensions.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 02/07/22.
//

import UIKit

extension UIImage {
    
    /// Scales down the image to fit the provided size.
    ///
    /// - parameter size: Measured in points.
    func scaledDown(to size: CGSize) -> UIImage {
        let originalSize = self.size
        var widthScale: CGFloat = 1
        var heightScale: CGFloat = 1
        
        if originalSize.width > size.width {
            widthScale = size.width / originalSize.width
        }
        
        if originalSize.height > size.height {
            heightScale = size.height / originalSize.height
        }
        
        let scaleFactor = min(widthScale, heightScale)
        let scaledSize = CGSize(
            width: originalSize.width * scaleFactor,
            height: originalSize.height * scaleFactor
        )
        
        let renderer = UIGraphicsImageRenderer(size: scaledSize)
        return renderer.image {_ in
            self.draw(in: CGRect(origin: .zero, size: scaledSize))
        }
    }
    
    /// Splits an image in 9 fragments of equal size.
    func splitForBoard() -> [UIImage] {
        let scale = scale
        let (tileWidth, tileHeight) = (size.width / 3 * scale, size.height / 3 * scale)
        var fragments = [UIImage]()
        
        for col in 0..<3 {
            for row in 0..<3 {
                let cropRect = CGRect(
                    x: CGFloat(row) * tileWidth,
                    y: CGFloat(col) * tileHeight,
                    width: tileWidth,
                    height: tileHeight
                )
                
                guard let img = cgImage?.cropping(to: cropRect) else {
                    fatalError("Cropping Failed")
                }
                
                let croppedImage = UIImage(cgImage: img)
                fragments.append(croppedImage)
            }
        }
        
        return fragments
    }
    
}
