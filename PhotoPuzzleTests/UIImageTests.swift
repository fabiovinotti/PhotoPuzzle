//
//  UIImageTests.swift
//  PhotoPuzzleTests
//
//  Created by Fabio Vinotti on 04/07/22.
//

import XCTest
@testable import PhotoPuzzle

class UIImageTests: XCTestCase {

    func testScaleDown() {
        let thisBundle = Bundle(for: type(of: self))
        
        guard let img = UIImage(named: "test-photo.jpg", in: thisBundle, with: nil) else {
            XCTFail("Unable to retrieve the test image.")
            return
        }
        
        let originalSize = img.size
        let scaledSize = CGSize(
            width: originalSize.width / 2,
            height: originalSize.width / 2
        )
        
        let scaledImage = img.scaledDown(to: scaledSize)
        
        XCTAssertEqual(scaledSize, scaledImage.size)
    }
}
