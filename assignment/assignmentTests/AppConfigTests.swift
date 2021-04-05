//
//  AppConfigTests.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import XCTest
@testable import assignment

class AppConfigTests: XCTestCase {
    
    let appConfig = AppConfig.sharedInstance

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testGetUnsplashAPIKey() {
        let unsplashAPIKey = appConfig.getUnsplashAPIKey()
        XCTAssertNotNil(unsplashAPIKey, "The Unsplash API Key should not be nil.")
        XCTAssertNotEqual(unsplashAPIKey, "", "The Unsplash API Key should not be an empty string.")
    }

}
