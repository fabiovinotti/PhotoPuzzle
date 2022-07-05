//
//  Networking.swift
//  PhotoPuzzle
//
//  Created by Fabio Vinotti on 30/06/22.
//

import UIKit

struct Networking {
    
    static let session: URLSession = {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.urlCache = nil
        configuration.httpCookieStorage = nil
        configuration.networkServiceType = .responsiveData
        configuration.allowsConstrainedNetworkAccess = true
        configuration.allowsExpensiveNetworkAccess = true
        return URLSession(configuration: configuration)
    }()
    
    /// Fetches an image at the provided URL.
    static func fetchImage(from url: URL, session: URLSession = Self.session) async throws -> UIImage {
        let data = try await fetchData(from: url, session: session)
        
        guard let image = UIImage(data: data) else {
            throw NetworkingError.invalidImageData
        }
        
        return image
    }
    
    /// Fetches the data at the provided URL.
    static func fetchData(from url: URL, session: URLSession = Self.session) async throws -> Data {
        try await withUnsafeThrowingContinuation { continuation in
            let task = session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    let networkingError = NetworkingError.requestFailed(error: error)
                    return continuation.resume(throwing: networkingError)
                }
                
                guard let data = data else {
                    fatalError()
                }
                
                guard let response = response as? HTTPURLResponse else {
                    return continuation.resume(throwing: NetworkingError.noResponse)
                }
                
                guard 200...299 ~= response.statusCode else {
                    let networkingError = NetworkingError.badResponse(statusCode: response.statusCode)
                    return continuation.resume(throwing: networkingError)
                }
                
                continuation.resume(returning: data)
            }
            
            task.resume()
        }
    }
    
}
