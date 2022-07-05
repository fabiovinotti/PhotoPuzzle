//
//  BoardControllerDelegate.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 30/06/22.
//

import Foundation

protocol BoardControllerDelegate {
    
    func boardControllerTileWasMoved(_ boardController: BoardController)
    
    func boardWasSolved(_ boardController: BoardController)
}
