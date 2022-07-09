//
//  BoardController.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 29/06/22.
//

import UIKit

private let reuseIdentifier = "BoardReusableTile"

class BoardController: UICollectionViewController {
    
    var delegate: BoardControllerDelegate?
    
    /// Whether all the tiles of the board are in the correct position or not.
    var isSolved: Bool {
        orderedImageTiles == shuffledImageTiles
    }
    
    let itemsPerRow: CGFloat = 3
    
    private var orderedImageTiles = [UIImage]()
    private var shuffledImageTiles = [UIImage]()
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(BoardCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.isScrollEnabled = false
        collectionView.dragInteractionEnabled = true
        collectionView.dragDelegate = self
        collectionView.dropDelegate = self
        collectionView.backgroundColor = .tertiarySystemBackground
    }
    
    /// Set the board's image.
    ///
    /// When a new image is set, the tiles of the board are updated with its fragments and shuffled.
    func resetBoard(with image: UIImage) {
        orderedImageTiles = image.splitForBoard()
        shuffledImageTiles = orderedImageTiles.shuffled()
        collectionView.reloadData()
    }
    
    /// Checks if a tile is placed correctly or not.
    func checkTilePositionCorrectness(_ indexPath: IndexPath) -> Bool {
        shuffledImageTiles[indexPath.item] == orderedImageTiles[indexPath.item]
    }
}

// MARK: UICollectionViewDataSource

extension BoardController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledImageTiles.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath
        ) as! BoardCell
        
        cell.image = shuffledImageTiles[indexPath.item]
        return cell
    }
}

// MARK: - Flow Layout Delegate

extension BoardController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sizeWithoutSpacing = collectionView.frame.width - 2
        let sizePerItem = sizeWithoutSpacing / itemsPerRow
        
        return CGSize(width: sizePerItem, height: sizePerItem)
    }
    
}

// MARK: - DragDelegate

extension BoardController: UICollectionViewDragDelegate {
    
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        
        if checkTilePositionCorrectness(indexPath) {
            // Tile location is correct. Dragging is not allowed.
            return []
        }
        
        let item = shuffledImageTiles[indexPath.item]
        let itemProvider = NSItemProvider(object: item)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        return [dragItem]
    }
    
}

// MARK: - DropDelegate

extension BoardController: UICollectionViewDropDelegate {
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        
        guard collectionView.hasActiveDrag,
              session.items.count == 1,
              let destinationIndexPath = destinationIndexPath
        else {
            return UICollectionViewDropProposal(operation: .cancel)
        }
        
        if checkTilePositionCorrectness(destinationIndexPath) {
            return UICollectionViewDropProposal(operation: .forbidden)
        }
        
        return UICollectionViewDropProposal(operation: .move, intent: .insertIntoDestinationIndexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        
        guard let destinationIndexPath = coordinator.destinationIndexPath else {
            print("Destination index path was nil when performing drop.")
            return
        }
        
        for item in coordinator.items {
            guard let sourceIndexPath = item.sourceIndexPath else {
                // Dropping items dragged from other app is not allowed.
                return
            }
            
            shuffledImageTiles.swapAt(sourceIndexPath.item, destinationIndexPath.item)
            collectionView.reloadItems(at: [sourceIndexPath, destinationIndexPath])
            coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
            delegate?.boardControllerTileWasMoved(self)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, dropSessionDidEnd session: UIDropSession) {
        if isSolved {
            delegate?.boardWasSolved(self)
        }
    }
}
