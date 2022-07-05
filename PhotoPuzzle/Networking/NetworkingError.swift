//
//  NetworkingError.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 30/06/22.
//

import Foundation

enum NetworkingError: Error, CustomStringConvertible {
    case requestFailed(error: Error)
    case noResponse
    case badResponse(statusCode: Int)
    case invalidImageData
    
    // Description for the user.
    var localizedDescription: String {
        switch self {
        case .requestFailed(let error):
            return error.localizedDescription
            
        case .noResponse, .badResponse:
            return "The connection to the server failed."
            
        case .invalidImageData:
            return "Failed to download the puzzle's image."
        }
    }
    
    var description: String {
        switch self {
        case .requestFailed(let error):
            return "URLSession.dataTask error: \(error.localizedDescription)"
            
        case .noResponse:
            return "The request returned an invalid response."
            
        case .badResponse(statusCode: let statusCode):
            return "Bad response with status code: \(statusCode)"
            
        case .invalidImageData:
            return "Failed to create a UIImage with the fetched data."
        }
    }
}
