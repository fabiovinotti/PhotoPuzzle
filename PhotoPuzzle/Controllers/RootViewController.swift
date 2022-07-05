//
//  RootViewController.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 27/06/22.
//

import UIKit

class RootViewController: UIViewController {
    
    private lazy var titleLabel: UILabel = {
        let l = UILabel()
        let font = UIFont.boldSystemFont(ofSize: 32)
        l.font = UIFontMetrics(forTextStyle: .title1).scaledFont(for: font)
        l.text = "Photo Puzzle"
        l.textColor = .label
        l.adjustsFontForContentSizeCategory = true
        l.textAlignment = .natural
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var welcomeMessageLabel: UILabel = {
        let l = UILabel()
        l.text = "Solve cool picture-based puzzles"
        l.textColor = .secondaryLabel
        l.font = .preferredFont(forTextStyle: .headline)
        l.adjustsFontForContentSizeCategory = true
        l.textAlignment = .natural
        l.numberOfLines = 1
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private lazy var startButton: UIButton = {
        let b = PillButton(type: .system)
        b.accessibilityIdentifier = "start-game-button"
        b.setTitle("Get started", for: .normal)
        b.titleLabel?.font = .boldSystemFont(ofSize: 15)
        b.sizeToFit()
        b.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(startButton)
        
        let sv = UIStackView(arrangedSubviews: [titleLabel, welcomeMessageLabel])
        sv.axis = .vertical
        sv.alignment = .center
        sv.distribution = .equalCentering
        sv.spacing = 20
        sv.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(sv)
        
        let margins = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            sv.centerYAnchor.constraint(equalTo: margins.centerYAnchor),
            sv.leadingAnchor.constraint(equalTo: margins.leadingAnchor),
            sv.trailingAnchor.constraint(equalTo: margins.trailingAnchor),
            
            startButton.bottomAnchor.constraint(equalTo: margins.bottomAnchor),
            startButton.centerXAnchor.constraint(equalTo: margins.centerXAnchor),
            startButton.widthAnchor.constraint(equalTo: margins.widthAnchor, multiplier: 0.85)
        ])
    }
    
    @objc private func startNewGame() {
        let gameController = GameViewController()
        gameController.modalPresentationStyle = .fullScreen
        gameController.modalTransitionStyle = .crossDissolve
        present(gameController, animated: true)
      }
}
