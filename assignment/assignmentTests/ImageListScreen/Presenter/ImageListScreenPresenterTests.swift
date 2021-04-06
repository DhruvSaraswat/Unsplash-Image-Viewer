//
//  ImageListScreenPresenterTests.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import XCTest
@testable import assignment

class ImageListScreenPresenterTests: XCTestCase {
    
    var view: ImageScreenViewMock!
    var interactor: ImageScreenInteractorMock!
    var presenter: ImageListScreenPresenter!
    
    override func setUp() {
        super.setUp()
        
        view = ImageScreenViewMock()
        interactor = ImageScreenInteractorMock()
        presenter = ImageListScreenPresenter()
        presenter.view = view
        presenter.interactor = interactor
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
    }
    
    func testUpdateView() {
        presenter.updateView(withPage: 209)
        XCTAssertTrue(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testFetchUnsplashImageDetails_WhenIndexIsNotOutOfBounds() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        for _ in 0..<5 {
            unsplashImageDetailsList.append(Utility.generateRandomUnsplashImageDetails())
        }
        // Create a presenter with 5 array elements.
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        
        // Now assert that all 5 array elements have non-nil values, and none of the view and interactor methods should be called.
        
        for i in 0..<5 {
            let unsplashImageDetails = presenter.fetchUnsplashImageDetails(atIndex: i)
            XCTAssertNotNil(unsplashImageDetails, "unsplashImageDetails should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.blur_hash, "blur_hash should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.height, "height should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.width, "width should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.urls?.full, "full URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.urls?.raw, "raw URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.urls?.regular, "regular URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.urls?.small, "small URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.urls?.thumb, "thumb URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.user?.profile_image?.large, "large profile Image URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.user?.profile_image?.medium, "medium profile Image URL should not be nil.")
            XCTAssertNotNil(unsplashImageDetails.user?.profile_image?.small, "small profile Image URL should not be nil.")
            XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
            XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
            XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        }
    }
    
    func testFetchUnsplashImageDetails_WhenIndexIsOutOfBounds() {
        let unsplashImageDetails = presenter.fetchUnsplashImageDetails(atIndex: 1000)
        XCTAssertNotNil(unsplashImageDetails, "unsplashImageDetails should not be nil.")
        XCTAssertNil(unsplashImageDetails.blur_hash, "blur_hash should be nil.")
        XCTAssertNil(unsplashImageDetails.height, "height should be nil.")
        XCTAssertNil(unsplashImageDetails.width, "width should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.full, "full URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.raw, "raw URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.regular, "regular URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.small, "small URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.thumb, "thumb URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.large, "large profile Image URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.medium, "medium profile Image URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.small, "small profile Image URL should be nil.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testFetchUnsplashImageDetails_WhenIndexIsNegative() {
        // This will never happen, because cells are 0-indexed. However since the presenter is not aware of this, there is an explicit unit test for this scenario as well.
        let randomNegativeInteger = (Utility.generateRandomPositiveInteger(inclusive: 10, exclusive: 100) ?? 1) * (-1)
        let unsplashImageDetails = presenter.fetchUnsplashImageDetails(atIndex: randomNegativeInteger)
        XCTAssertNotNil(unsplashImageDetails, "unsplashImageDetails should not be nil.")
        XCTAssertNil(unsplashImageDetails.blur_hash, "blur_hash should be nil.")
        XCTAssertNil(unsplashImageDetails.height, "height should be nil.")
        XCTAssertNil(unsplashImageDetails.width, "width should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.full, "full URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.raw, "raw URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.regular, "regular URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.small, "small URL should be nil.")
        XCTAssertNil(unsplashImageDetails.urls?.thumb, "thumb URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.large, "large profile Image URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.medium, "medium profile Image URL should be nil.")
        XCTAssertNil(unsplashImageDetails.user?.profile_image?.small, "small profile Image URL should be nil.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testOnImagesFetched() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        for _ in 0..<5 {
            unsplashImageDetailsList.append(Utility.generateRandomUnsplashImageDetails())
        }
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsDisplayed, 5, "The count of images displayed should be 5 initially.")
        
        presenter.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList) // on fetching 5 more unsplashImageDetails.
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsDisplayed, 10,
                       "The count of images displayed should be 5 (initially) + 5 (added now) = 10.")
        XCTAssertTrue(view.isShowImagesMethodCalled, "The showImages() view method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
    }
    
    func testOnImagesFetchError() {
        let randomError = Error.allCases.randomElement()!
        presenter.onImagesFetchError(error: randomError)
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertTrue(view.isShowErrorMethodCalled, "The showError() view method should be called.")
    }
    
}

class ImageScreenViewMock: PresenterToViewImageListScreenProtocol {
    var isShowImagesMethodCalled = false
    var isShowErrorMethodCalled = false
    
    func showImages() {
        isShowImagesMethodCalled = true
    }
    
    func showError() {
        isShowErrorMethodCalled = true
    }
}

class ImageScreenInteractorMock: PresenterToInteractorImageListScreenProtocol {
    var presenter: InteractorToPresenterImageListScreenProtocol?
    
    var isLoadRandomImagesMethodCalled = false
    
    func loadRandomImages(withPage page: Int) {
        XCTAssertEqual(page, 209, "The page value should be 209.")
        isLoadRandomImagesMethodCalled = true
    }
}
