//
//  PillButton.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 02/07/22.
//

import UIKit

class PillButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        backgroundColor = UIColor(named: "AccentColor")
        layer.masksToBounds = true
        contentEdgeInsets = .init(top: 12, left: 30, bottom: 12, right: 30)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
}
