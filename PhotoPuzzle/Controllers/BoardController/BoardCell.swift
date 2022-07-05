//
//  BoardCell.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 29/06/22.
//

import UIKit

class BoardCell: UICollectionViewCell {
    
    var image: UIImage? {
        get { imgView.image }
        set { imgView.image = newValue }
    }
    
    private let imgView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundView = imgView
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
