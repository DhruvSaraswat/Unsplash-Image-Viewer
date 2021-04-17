//
//  ImageListScreenInteractorTests.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import XCTest
@testable import assignment

class ImageListScreenInteractorTests: XCTestCase {
    
    var presenter: MockPresenter!
    fileprivate var networkLayerMock: NetworkLayerMock!
    var interactor: ImageListScreenInteractorMockWithInit!

    override func setUp() {
        super.setUp()
        presenter = MockPresenter()
        networkLayerMock = NetworkLayerMock()
        interactor = ImageListScreenInteractorMockWithInit()
        interactor.networkLayer = networkLayerMock
        interactor.presenter = presenter
    }

    override func tearDown() {
        super.tearDown()
    }

    func testLoadRandomImages_WhenAPICallIsSuccessful() throws {
        networkLayerMock.isLoadRandomImagesAPICallSuccessful = true
        interactor.loadRandomImages(withPage: 29)
        XCTAssertTrue(presenter.isOnImagesFetchedMethodCalled, "The onImagesFetched() presenter method should be called.")
        XCTAssertFalse(presenter.isOnImagesFetchErrorMethodCalled, "The onImagesFetchError() presenter method should not be called.")
    }
    
    func testLoadRandomImages_WhenAPICallFails() throws {
        networkLayerMock.isLoadRandomImagesAPICallSuccessful = false
        interactor.loadRandomImages(withPage: 29)
        XCTAssertTrue(presenter.isOnImagesFetchErrorMethodCalled, "The onImagesFetchError() presenter method should be called.")
        XCTAssertFalse(presenter.isOnImagesFetchedMethodCalled, "The onImagesFetched() presenter method should not be called.")
    }
    
    func testLoadImage() throws {
        let url = URL(string: "https://example.com")
        interactor.networkLayer?.loadImage(from: url!, completion: nil)
        XCTAssertFalse(presenter.isOnImagesFetchErrorMethodCalled, "The onImagesFetchError() presenter method should not be called.")
        XCTAssertFalse(presenter.isOnImagesFetchedMethodCalled, "The onImagesFetched() presenter method should not be called.")
    }

}

class ImageListScreenInteractorMockWithInit: XCTestCase, PresenterToInteractorImageListScreenProtocol {
    var presenter: InteractorToPresenterImageListScreenProtocol?
    var networkLayer: NetworkLayerProtocol?
    let expectation = XCTestExpectation (description: "Verify that the completion handler in loadRandomImages() was called and executed.")
    
    func loadRandomImages(withPage page: Int) {
        XCTAssertEqual(page, 29, "The page value should be 29.")
        self.networkLayer?.loadRandomImages(withPage: page, resultsPerPage: 11) { (result, linkHeaderValue) in
            switch result {
            case .success(let successResponse):
                XCTAssertEqual(successResponse.count, 1, "There should be 1 value in the success response array.")
                XCTAssertEqual(successResponse[0].alt_description, "alt_description_Value", "alt_description value should be alt_description_Value.")
                XCTAssertEqual(successResponse[0].description, "description_Value", "description value should be description_Value.")
                XCTAssertEqual(successResponse[0].blur_hash, "blurHash_value", "blur_hash value should be blurHash_value.")
                XCTAssertEqual(successResponse[0].user?.profile_image?.small, "profileImageURL_Value",
                               "small profile_image URL value should be profileImageURL_Value.")
                XCTAssertEqual(successResponse[0].user?.location, "location_Value", "location value should be location_Value.")
                XCTAssertEqual(successResponse[0].user?.name, "name_Value", "name value should be name_Value.")
                XCTAssertEqual(successResponse[0].urls?.full, "fullImageURL_Value", "full imamge URL value should be fullImageURL_Value.")
                XCTAssertEqual(linkHeaderValue, "abcdef", "linkHeaderValue value should be abcdef.")
                self.presenter?.onImagesFetched(unsplashImageDetailsList: successResponse, linkHeaderValue: linkHeaderValue)
                self.expectation.fulfill()
                
            case .failure(let error):
                XCTAssertEqual(error, Error.generic, "The error should be generic.")
                self.presenter?.onImagesFetchError(error: error)
                self.expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3)
    }
}

fileprivate class NetworkLayerMock: NetworkLayerProtocol {
    var isLoadRandomImagesAPICallSuccessful = false
    
    func loadRandomImages(withPage page: Int,
                          resultsPerPage: Int,
                          completion: @escaping (Result<[UnsplashImageDetails], Error>, String?) -> Void) {
        XCTAssertEqual(page, 29, "page value should be 29.")
        XCTAssertEqual(resultsPerPage, 11, "resultsPerPage value should be 11.")
        if isLoadRandomImagesAPICallSuccessful {
            var unsplashImageDetailsList = [UnsplashImageDetails]()
            unsplashImageDetailsList.append(Utility.generateUnsplashUserImageDetailsWithSpecificValues())
            completion(.success(unsplashImageDetailsList), "abcdef")
        } else {
            completion(.failure(Error.generic), "") // call the completion handler with a specific (instead of random) Error so that its value can be asserted.
        }
    }
    
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)?) {
        let expectedURL = URL(string: "https://example.com")
        XCTAssertEqual(expectedURL, url, "The URL should be \(url).")
    }
    
}

class MockPresenter: XCTestCase, InteractorToPresenterImageListScreenProtocol {
    var isOnImagesFetchedMethodCalled = false
    var isOnImagesFetchErrorMethodCalled = false
    
    func onImagesFetched(unsplashImageDetailsList: [UnsplashImageDetails], linkHeaderValue: String?) {
        XCTAssertEqual(unsplashImageDetailsList.count, 1, "There should be 1 value in the success response array.")
        XCTAssertEqual(unsplashImageDetailsList[0].alt_description, "alt_description_Value", "alt_description value should be alt_description_Value.")
        XCTAssertEqual(unsplashImageDetailsList[0].description, "description_Value", "description value should be description_Value.")
        XCTAssertEqual(unsplashImageDetailsList[0].blur_hash, "blurHash_value", "blur_hash value should be blurHash_value.")
        XCTAssertEqual(unsplashImageDetailsList[0].user?.profile_image?.small, "profileImageURL_Value",
                       "small profile_image URL value should be profileImageURL_Value.")
        XCTAssertEqual(unsplashImageDetailsList[0].user?.location, "location_Value", "location value should be location_Value.")
        XCTAssertEqual(unsplashImageDetailsList[0].user?.name, "name_Value", "name value should be name_Value.")
        XCTAssertEqual(unsplashImageDetailsList[0].urls?.full, "fullImageURL_Value", "full imamge URL value should be fullImageURL_Value.")
        isOnImagesFetchedMethodCalled = true
    }
    
    func onImagesFetchError(error: Error) {
        XCTAssertEqual(error, Error.generic, "The error value sent from interactor to presenter should be generic.")
        isOnImagesFetchErrorMethodCalled = true
    }
}
