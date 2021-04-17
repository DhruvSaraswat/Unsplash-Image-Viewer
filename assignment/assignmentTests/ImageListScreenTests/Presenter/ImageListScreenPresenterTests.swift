//
//  ImageListScreenPresenterTests.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import XCTest
@testable import assignment

class ImageListScreenPresenterTests: XCTestCase {
    
    var view: ImageListScreenViewMock!
    var interactor: ImageListScreenInteractorMock!
    var router: ImageListScreenRouterMock!
    var presenter: ImageListScreenPresenter!
    
    override func setUp() {
        super.setUp()
        
        view = ImageListScreenViewMock()
        interactor = ImageListScreenInteractorMock()
        router = ImageListScreenRouterMock()
        presenter = ImageListScreenPresenter()
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
    }
    
    override func tearDown() {
        super.tearDown()
        presenter = nil
    }
    
    func testUpdateView_WhenHasScreenRefreshedIsFalse() {
        presenter.updateView(withPage: 209, hasScreenRefreshed: false)
        XCTAssertTrue(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
    }
    
    func testUpdateView_WhenHasScreenRefreshedIsTrue() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        for _ in 0..<5 {
            unsplashImageDetailsList.append(Utility.generateRandomUnsplashImageDetails())
        }
        // Create a presenter with 5 array elements.
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsFetched, 5, "There should be 5 unsplashImageDetails stored in presenter.")
        presenter.updateView(withPage: 209, hasScreenRefreshed: true)
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsFetched, 0, "Now, there should be 0 unsplashImageDetails stored in presenter.")
        XCTAssertTrue(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
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
        presenter.router = router
        
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
            
            // None of the interactor, view or router methods should be called.
            XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
            XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
            XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
            XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
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
        
        // None of the interactor, view or router methods should be called.
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
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
        
        // None of the interactor, view or router methods should be called.
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
    }
    
    func testOnImagesFetched() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        for _ in 0..<5 {
            unsplashImageDetailsList.append(Utility.generateRandomUnsplashImageDetails())
        }
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsFetched, 5, "The count of images displayed should be 5 initially.")
        
        presenter.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList, linkHeaderValue: "") // on fetching 5 more unsplashImageDetails.
        XCTAssertEqual(presenter.currentCountOfUnsplashImageDetailsFetched, 10,
                       "The count of images displayed should be 5 (initially) + 5 (added now) = 10.")
        XCTAssertTrue(view.isShowImagesMethodCalled, "The showImages() view method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
    }
    
    func testOnImagesFetchError() {
        let randomError = Error.allCases.randomElement()!
        presenter.onImagesFetchError(error: randomError)
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertTrue(view.isShowErrorMethodCalled, "The showError() view method should be called.")
        XCTAssertFalse(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenAllValuesAreNonNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        unsplashImageDetailsList.append(Utility.generateUnsplashUserImageDetailsWithSpecificValues())
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenBlurHashIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.blur_hash = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isBlurHashValueNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenFullURLIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.urls?.full = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isFullImageURLNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenLocationIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.user?.location = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isLocationNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenImageDescriptionAndAltDescriptionIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.alt_description = nil
        unsplashImageDetails.description = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isImageDescriptionNil = true
        router.isImageAltDescriptionNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenImageDescriptionIsNilAndAltDescriptionIsNotNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.description = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isImageDescriptionNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenSmallProfileImageURLIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.user?.profile_image?.small = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isSmallProfileImageURLNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenNameIsNilAndUsernameIsNotNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.user?.name = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isNameNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenNameIsNotNilAndUsernameIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.user?.username = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isUsernameNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
    func testPushToImageDetailsScreen_WhenNameAndUsernameIsNil() {
        var unsplashImageDetailsList = [UnsplashImageDetails]()
        var unsplashImageDetails = Utility.generateUnsplashUserImageDetailsWithSpecificValues()
        unsplashImageDetails.user?.name = nil
        unsplashImageDetails.user?.username = nil
        unsplashImageDetailsList.append(unsplashImageDetails)
        presenter = ImageListScreenPresenter(unsplashImageDetailsList)
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = router
        
        router.isNameNil = true
        router.isUsernameNil = true
        
        presenter.pushToImageDetailsScreen(selectedCellIndex: 0)
        XCTAssertTrue(router.isPushToDetailsScreenMethodCalled, "The pushToDetailsScreen() router method should be called.")
        XCTAssertFalse(interactor.isLoadRandomImagesMethodCalled, "The loadRandomImages() interactor method should not be called.")
        XCTAssertFalse(view.isShowErrorMethodCalled, "The showError() view method should not be called.")
        XCTAssertFalse(view.isShowImagesMethodCalled, "The showImages() view method should not be called.")
    }
    
}

class ImageListScreenViewMock: PresenterToViewImageListScreenProtocol {
    var isShowImagesMethodCalled = false
    var isShowErrorMethodCalled = false
    
    func showImages() {
        isShowImagesMethodCalled = true
    }
    
    func showError() {
        isShowErrorMethodCalled = true
    }
}

class ImageListScreenInteractorMock: PresenterToInteractorImageListScreenProtocol {
    var presenter: InteractorToPresenterImageListScreenProtocol?
    
    var isLoadRandomImagesMethodCalled = false
    
    func loadRandomImages(withPage page: Int) {
        XCTAssertEqual(page, 209, "The page value should be 209.")
        isLoadRandomImagesMethodCalled = true
    }
}

class ImageListScreenRouterMock: PresenterToRouterImageListScreenProtocol {
    var isPushToDetailsScreenMethodCalled = false
    var isBlurHashValueNil = false
    var isFullImageURLNil = false
    var isLocationNil = false
    var isImageDescriptionNil = false
    var isImageAltDescriptionNil = false
    var isSmallProfileImageURLNil = false
    var isNameNil = false
    var isUsernameNil = false
    
    static func createModule() -> UINavigationController {
        return UINavigationController()
    }
    
    func pushToDetailsScreen(withBlurHash blurHash: String,
                             withURL fullImageURL: String,
                             withLocation location: String,
                             withImageDescription imageDescription: String,
                             withProfileImageURL profileImageURL: String,
                             withUserName name: String) {
        isPushToDetailsScreenMethodCalled = true
        if isBlurHashValueNil {
            XCTAssertEqual(blurHash, "", "The blurHash value sent to router should be an empty string when blurHash is nil.")
        } else {
            XCTAssertEqual(blurHash, "blurHash_value", "The blurHash value sent to router should be blurHash_value.")
        }
        if isFullImageURLNil {
            XCTAssertEqual(fullImageURL, "", "The fullImageURL value sent to router should be an empty string when fullImageURL is nil.")
        } else {
            XCTAssertEqual(fullImageURL, "fullImageURL_Value", "The fullImageURL value sent to router should be fullImageURL_Value.")
        }
        if isLocationNil {
            XCTAssertEqual(location, "Location not available", "The location value sent to router should Location not available.")
        } else {
            XCTAssertEqual(location, "location_Value", "The location value sent to router should be location_Value.")
        }
        if isImageDescriptionNil {
            if isImageAltDescriptionNil {
                XCTAssertEqual(imageDescription, "Image description not available", "The imageDescription value sent to router should be Image description not available.")
            } else {
                XCTAssertEqual(imageDescription, "alt_description_Value", "The imageDescription value sent to router should be alt_description_Value.")
            }
        } else {
            XCTAssertEqual(imageDescription, "description_Value", "The imageDescription value sent to router should be description_Value.")
        }
        if isSmallProfileImageURLNil {
            XCTAssertEqual(profileImageURL, "", "The profileImageURL value sent to router should be an empty string.")
        } else {
            XCTAssertEqual(profileImageURL, "profileImageURL_Value", "The profileImageURL value sent to router should be profileImageURL_Value.")
        }
        if isNameNil {
            if isUsernameNil {
                XCTAssertEqual(name, "Name not available", "The name value sent to router should be Name not available.")
            } else {
                XCTAssertEqual(name, "username_Value", "The name value sent to router should be username_Value.")
            }
        } else {
            XCTAssertEqual(name, "name_Value", "The name value sent to router should be name_Value.")
        }
    }
    
}
