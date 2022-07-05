//
//  MockURLProtocol.swift
//  PhotoPuzzleTests
//
//  Created by Fabio Vinotti on 05/07/22.
//

import Foundation

class MockURLProtocol: URLProtocol {
    
    static private var data: Data?
    static private var response: URLResponse?
    static private var error: Error?
    
    static func setParameters(data: Data? = nil, response: URLResponse? = nil, error: Error? = nil) {
        self.data = data
        self.response = response
        self.error = error
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        if let data = Self.data {
            client?.urlProtocol(self, didLoad: data)
        }
        
        if let response = Self.response {
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        }
        
        if let error = Self.error {
            client?.urlProtocol(self, didFailWithError: error)
        }
        
        client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
}
