//
//  NetworkingTests.swift
//  PhotoPuzzleTests
//
//  Created by Fabio Vinotti on 03/07/22.
//

import XCTest
@testable import PhotoPuzzle

class NetworkingTests: XCTestCase {
    
    let session: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }()
    
    let imageURL: URL = {
        let thisBundle = Bundle(for: NetworkingTests.self)
        return thisBundle.url(forResource: "test-photo", withExtension: "jpg")!
    }()
    
    func testFetchData() async throws {
        let response = HTTPURLResponse(
            url: imageURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let data = try Data(contentsOf: imageURL)
        
        MockURLProtocol.setParameters(data: data, response: response)
        
        let returnedData = try await Networking.fetchData(from: imageURL, session: session)
        XCTAssertEqual(returnedData, data)
    }
    
    func testFetchImage() async throws {
        let response = HTTPURLResponse(
            url: imageURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        let data = try Data(contentsOf: imageURL)
        
        MockURLProtocol.setParameters(data: data, response: response)
        
        _ = try await Networking.fetchImage(from: imageURL, session: session)
    }
    
    func testRequestFailedError() async {
        let dummyError = NSError(domain: "dummy-domain", code: 0)        
        MockURLProtocol.setParameters(data: nil, response: nil, error: dummyError)
        
        do {
            _ = try await Networking.fetchData(from: imageURL, session: session)
            XCTFail("No error has been thrown")
        } catch NetworkingError.requestFailed(error: let e) {
            XCTAssertNotNil(e as NSError)
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
    
    func testNoResponseError() async throws {
        MockURLProtocol.setParameters(data: nil, response: nil, error: nil)
        
        do {
            _ = try await Networking.fetchData(from: imageURL, session: session)
            XCTFail("No error has been thrown")
        } catch NetworkingError.noResponse {
            // Expected error thrown.
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
    
    func testBadResponseError() async {
        let response = HTTPURLResponse(
            url: imageURL,
            statusCode: 300,
            httpVersion: nil,
            headerFields: nil
        )
        
        MockURLProtocol.setParameters(data: nil, response: response)
        
        do {
            _ = try await Networking.fetchData(from: imageURL, session: session)
        } catch NetworkingError.badResponse(statusCode: let code) {
            XCTAssertEqual(code, 300)
        } catch {
            XCTFail()
        }
    }
    
    func testInvalidImageDataError() async throws {
        let response = HTTPURLResponse(
            url: imageURL,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )
        
        MockURLProtocol.setParameters(data: Data(), response: response)
        
        do {
        _ = try await Networking.fetchImage(from: imageURL, session: session)
            XCTFail("No error has been thrown")
        } catch NetworkingError.invalidImageData {
            // Expected error thrown.
        } catch {
            XCTFail("Wrong error thrown")
        }
    }
    
}
