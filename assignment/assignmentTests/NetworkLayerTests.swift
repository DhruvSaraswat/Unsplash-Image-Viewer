//
//  NetworkLayerTests.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import XCTest
@testable import assignment

class NetworkLayerTests: XCTestCase {
    
    var networkLayer: NetworkLayer!
    var expectation: XCTestExpectation!
    let getUnsplashPhotosAPIURL = URL(string: "https://api.unsplash.com/photos?client_id=abcd&page=1&per_page=15")!

    override func setUp() {
        super.setUp()
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        let urlSession = URLSession.init(configuration: configuration)
        networkLayer = NetworkLayer(urlSession: urlSession, clientID: "abcd")
        expectation = expectation(description: "Expectation")
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadRandomImages_WhenTheClientIDIsEmpty() {
        networkLayer = NetworkLayer(clientID: "")
        let jsonStringSuccessResponse = """
[
    {
        "width": 10,
        "height": 10,
        "blur_hash": "fvsfs",
        "urls": {
            "raw": "raw_url_here",
            "full": "full_url_here",
            "regular": "regular_url_here",
            "small": "small_url_here",
            "thumb": "thumb_url_here"
        },
        "user": {
            "profile_image": {
                "small": "small_image_url",
                "medium": "medium_image_url",
                "large": "large_image_url"
            }
        }
    }
]
"""
        let data = jsonStringSuccessResponse.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.getUnsplashPhotosAPIURL else {
                fatalError("The URL value \(String(describing: request.url)) is not equal to the expected URL \(self.getUnsplashPhotosAPIURL)")
            }
            let response = HTTPURLResponse(url: self.getUnsplashPhotosAPIURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        networkLayer.loadRandomImages(withPage: 1, resultsPerPage: 15) { (result, linkHeaderValue) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected, because the clientID is empty.")
                
            case .failure(let error):
                XCTAssertEqual(error, Error.invalidClientID, "The error should be invalid clientID.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRandomImages_WhenThereIsAJSONParsingError() {
        /// In `invalidJSONResponse` below, the values of `width` and `height` are `Strings`, whereas they shoulld be `Ints`
        /// This makes the below JSON an invalid reponse, and it should result in `Error.unableToParseResponse`.
        let invalidJSONResponse = """
[
    {
        "width": "10",
        "height": "10",
        "blur_hash": "fvsfs",
        "urls": {
            "raw": "raw_url_here",
            "full": "full_url_here",
            "regular": "regular_url_here",
            "small": "small_url_here",
            "thumb": "thumb_url_here"
        },
        "user": {
            "profile_image": {
                "small": "small_image_url",
                "medium": "medium_image_url",
                "large": "large_image_url"
            }
        }
    }
]
"""
        let data = invalidJSONResponse.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.getUnsplashPhotosAPIURL else {
                fatalError("The URL value \(String(describing: request.url)) is not equal to the expected URL \(self.getUnsplashPhotosAPIURL)")
            }
            let response = HTTPURLResponse(url: self.getUnsplashPhotosAPIURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        networkLayer.loadRandomImages(withPage: 1, resultsPerPage: 15) { (result, linkHeaderValue) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected, because the JSON response is invalid.")
                
            case .failure(let error):
                XCTAssertEqual(error, Error.unableToParseResponse, "The error should be unableToParseResponse.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRandomImages_WhenTheResponseIsAnythingApartFrom200() {
        let jsonStringSuccessResponse = """
[
    {
        "width": 10,
        "height": 10,
        "blur_hash": "fvsfs",
        "urls": {
            "raw": "raw_url_here",
            "full": "full_url_here",
            "regular": "regular_url_here",
            "small": "small_url_here",
            "thumb": "thumb_url_here"
        },
        "user": {
            "profile_image": {
                "small": "small_image_url",
                "medium": "medium_image_url",
                "large": "large_image_url"
            }
        }
    }
]
"""
        let data = jsonStringSuccessResponse.data(using: .utf8)
        
        let randomErrorResponseCode = Utility.generateRandomPositiveInteger(inclusive: 400, exclusive: 600)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.getUnsplashPhotosAPIURL else {
                fatalError("The URL value \(String(describing: request.url)) is not equal to the expected URL \(self.getUnsplashPhotosAPIURL)")
            }
            let response = HTTPURLResponse(url: self.getUnsplashPhotosAPIURL, statusCode: randomErrorResponseCode ?? 0, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        networkLayer.loadRandomImages(withPage: 1, resultsPerPage: 15) { (result, linkHeaderValue) in
            switch result {
            case .success(_):
                XCTFail("Success was not expected, because the response code is not 200.")
                
            case .failure(let error):
                XCTAssertEqual(error, Error.unknownAPIResponse, "The error should be unknownAPIResponse.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testLoadRandomImages_SuccessfulResponse() {
        let jsonStringSuccessResponse = """
[
    {
        "width": 10,
        "height": 10,
        "blur_hash": "fvsfs",
        "urls": {
            "raw": "raw_url_here",
            "full": "full_url_here",
            "regular": "regular_url_here",
            "small": "small_url_here",
            "thumb": "thumb_url_here"
        },
        "user": {
            "profile_image": {
                "small": "small_image_url",
                "medium": "medium_image_url",
                "large": "large_image_url"
            }
        }
    }
]
"""
        let data = jsonStringSuccessResponse.data(using: .utf8)
        
        MockURLProtocol.requestHandler = { request in
            guard let url = request.url, url == self.getUnsplashPhotosAPIURL else {
                fatalError("The URL value \(String(describing: request.url)) is not equal to the expected URL \(self.getUnsplashPhotosAPIURL)")
            }
            let response = HTTPURLResponse(url: self.getUnsplashPhotosAPIURL, statusCode: 200, httpVersion: nil, headerFields: nil)!
            return (response, data)
        }
        
        networkLayer.loadRandomImages(withPage: 1, resultsPerPage: 15) { (result, linkHeaderValue) in
            switch result {
            case .success(let unsplashImageDetailsList):
                XCTAssertEqual(unsplashImageDetailsList.count, 1, "There should be only 1 item in the response array.")
                XCTAssertEqual(unsplashImageDetailsList[0].width, 10, "The width should be 10.")
                XCTAssertEqual(unsplashImageDetailsList[0].height, 10, "The height should be 10.")
                XCTAssertEqual(unsplashImageDetailsList[0].blur_hash, "fvsfs", "The blur_hash should be fvsfs.")
                XCTAssertEqual(unsplashImageDetailsList[0].urls?.raw, "raw_url_here", "The raw URL should be raw_url_here.")
                XCTAssertEqual(unsplashImageDetailsList[0].urls?.full, "full_url_here", "The full URL should be full_url_here.")
                XCTAssertEqual(unsplashImageDetailsList[0].urls?.regular, "regular_url_here", "The regular URL should be regular_url_here.")
                XCTAssertEqual(unsplashImageDetailsList[0].urls?.small, "small_url_here", "The small URL should be small_url_here.")
                XCTAssertEqual(unsplashImageDetailsList[0].urls?.thumb, "thumb_url_here", "The thumb URL should be thumb_url_here.")
                XCTAssertEqual(unsplashImageDetailsList[0].user?.profile_image?.small, "small_image_url", "The small profile image URL should be small_image_url.")
                XCTAssertEqual(unsplashImageDetailsList[0].user?.profile_image?.medium, "medium_image_url", "The medium profile image URL should be medium_image_url.")
                XCTAssertEqual(unsplashImageDetailsList[0].user?.profile_image?.large, "large_image_url", "The large profile image URL should be large_image_url.")
                
            case .failure(_):
                XCTFail("Failure was not expected.")
            }
            self.expectation.fulfill()
        }
        wait(for: [expectation], timeout: 1.0)
    }

}

class MockURLProtocol: URLProtocol {
    static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data?))?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            XCTFail("Handler is unavailable")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            if let data = data {
                client?.urlProtocol(self, didLoad: data)
            }
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    override func stopLoading() {
    }
}
