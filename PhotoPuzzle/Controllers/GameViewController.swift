//
//  GameViewController.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 30/06/22.
//

import UIKit

class GameViewController: UIViewController {
    
    /// How many times the player swapped two tiles.
    private(set) var numberOfMoves: Int = 0 {
        didSet { movesLabel.label.text = "Moves: \(numberOfMoves)" }
    }
    
    private lazy var toolbar: UIToolbar = {
        let t = UIToolbar(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        t.delegate = self
        t.isTranslucent = false
        t.backgroundColor = .systemBackground
        t.translatesAutoresizingMaskIntoConstraints = false
        
        let exitPuzzleButton = UIBarButtonItem(
            image: UIImage(systemName: "arrow.left"),
            style: .plain,
            target: self,
            action: #selector(exitCurrentPuzzle)
        )
        
        let flexibleSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )
        
        let newPuzzleButton = UIBarButtonItem(
            image: UIImage(systemName: "puzzlepiece.fill"),
            style: .plain,
            target: self,
            action: #selector(newPuzzleButtonHandler)
        )
        
        t.setItems([exitPuzzleButton, flexibleSpace, newPuzzleButton], animated: false)
        return t
    }()
    
    private lazy var movesLabel: PillLabel = {
        let l = PillLabel()
        l.label.text = "Moves: 0"
        return l
    }()
    
    private lazy var loadingView: LoadingCoverView = {
        let lv = LoadingCoverView()
        lv.backgroundColor = .secondarySystemBackground
        lv.isHidden = true
        lv.translatesAutoresizingMaskIntoConstraints = false
        lv.layer.zPosition = 10
        return lv
    }()
    
    private var boardController: BoardController!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(toolbar)
        view.addSubview(movesLabel)
        view.addSubview(loadingView)
        setupBoardController()
        setupConstraints()
        loadNewPuzzle()
    }
    
    private func setupBoardController() {
        boardController = BoardController()
        boardController.delegate = self
        boardController.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(boardController)
        view.addSubview(boardController.view)
        
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            boardController.view.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            boardController.view.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            boardController.view.heightAnchor.constraint(equalTo: boardController.view.widthAnchor),
            boardController.view.centerYAnchor.constraint(equalTo: safeArea.centerYAnchor)
        ])
        
        boardController.didMove(toParent: self)
    }
    
    private func setupConstraints() {
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            // Toolbar
            toolbar.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            toolbar.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            toolbar.topAnchor.constraint(equalTo: safeArea.topAnchor),
            
            // Moves Label
            movesLabel.centerXAnchor.constraint(equalTo: safeArea.centerXAnchor),
            movesLabel.topAnchor.constraint(equalTo: boardController.view.bottomAnchor, constant: 20),
            
            // Loading Cover
            loadingView.topAnchor.constraint(equalTo: toolbar.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            loadingView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            loadingView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor)
        ])
    }
    
    @objc private func newPuzzleButtonHandler() {
        boardController.isSolved ? loadNewPuzzle() : presentLoadNewWhileUnsolvedAlert()
    }
    
    @objc private func exitCurrentPuzzle() {
        boardController.isSolved ? dismiss(animated: true) : presentCloseUnsolvedPuzzleAlert()
    }
    
    private func loadNewPuzzle() {
        showLoading()
        Task {
            do {
                let image = try await Networking.fetchImage(from: .randomPhotoURL)
                let screenSize = UIScreen.main.bounds.size
                let imageDesiredSize = CGSize(width: screenSize.width, height: screenSize.height)
                let scaledImage = image.scaledDown(to: imageDesiredSize)
                boardController.resetBoard(image: scaledImage)
                numberOfMoves = 0
                hideLoading()
            } catch let e as NetworkingError {
                hideLoading()
                presentLoadingFailureAlert(message: e.localizedDescription)
                print(e.description)
            } catch {
                fatalError("Unexpected kind of error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    /// Shows that a loading task is in progress and prevents the user from interacting with buttons.
    private func showLoading() {
        loadingView.startAnimating()
        loadingView.isHidden = false
        
        if let items = toolbar.items {
            items.forEach { $0.isEnabled = false }
        }
    }
    
    private func hideLoading() {
        loadingView.isHidden = true
        loadingView.stopAnimating()
        
        if let items = toolbar.items {
            items.forEach { $0.isEnabled = true }
        }
    }
    
    // MARK: - Alerts
    
    private func presentBoardIsSolvedAlert() {
        let alert = UIAlertController(
            title: "You made it!",
            message: """
            Wow, you solved the puzzle. \
            Do you feel like solving another one?
            """,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) {_ in
            self.loadNewPuzzle()
        })
        
        alert.addAction(UIAlertAction(title: "No", style: .cancel))
        
        alert.preferredAction = alert.actions[0]
        present(alert, animated: true, completion: nil)
    }
    
    private func presentLoadingFailureAlert(message: String) {
        let alert = UIAlertController(
            title: "Failed to load puzzle",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
        present(alert, animated: true)
    }
    
    private func presentCloseUnsolvedPuzzleAlert() {
        let alert = UIAlertController(
            title: "Unsolved puzzle",
            message: "Are you sure you want to close the current game? All progress will be lost.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Continue", style: .cancel))
        
        alert.addAction(UIAlertAction(title: "Close", style: .destructive) {_ in
            self.dismiss(animated: true)
        })
        
        alert.preferredAction = alert.actions[0]
        present(alert, animated: true)
    }
    
    private func presentLoadNewWhileUnsolvedAlert() {
        let alert = UIAlertController(
            title: "Unsolved Puzzle",
            message: "Are you sure you want to load a new puzzle? All progress will be lost.",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Load new", style: .destructive) {_ in
            self.loadNewPuzzle()
        })
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        alert.preferredAction = alert.actions[1]
        present(alert, animated: true)
    }
    
}

// MARK: - UIToolbarDelegate

extension GameViewController: UIToolbarDelegate {
    
    func position(for bar: UIBarPositioning) -> UIBarPosition {
        .topAttached
    }
    
}

// MARK: - BoardControllerDelegate

extension GameViewController: BoardControllerDelegate {
    
    func boardControllerTileWasMoved(_ boardController: BoardController) {
        DispatchQueue.main.async { [weak self] in
            self?.numberOfMoves += 1
        }
    }
    
    func boardWasSolved(_ boardController: BoardController) {
        DispatchQueue.main.async { [weak self] in
            self?.presentBoardIsSolvedAlert()
        }
    }
    
}
