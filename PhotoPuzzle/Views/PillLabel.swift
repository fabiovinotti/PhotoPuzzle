//
//  PillLabel.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 03/07/22.
//

import UIKit

/// A view that wraps a label to add a custom style.
class PillLabel: UIView {
    
    let label: UILabel = {
        let l = UILabel()
        l.numberOfLines = 1
        l.font = .preferredFont(forTextStyle: .subheadline)
        l.textColor = .label
        l.adjustsFontForContentSizeCategory = true
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.gray.withAlphaComponent(0.3).cgColor
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowOpacity = 1
        layer.shadowRadius = 4
        addSubview(label)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: label.topAnchor, constant: -7),
            leadingAnchor.constraint(equalTo: label.leadingAnchor, constant: -12),
            bottomAnchor.constraint(equalTo: label.bottomAnchor, constant: 7),
            trailingAnchor.constraint(equalTo: label.trailingAnchor, constant: 12)
        ])
    }
}
