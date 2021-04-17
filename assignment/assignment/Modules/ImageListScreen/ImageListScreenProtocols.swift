//
//  ImageListScreenProtocols.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 05/04/21.
//

import UIKit

protocol ViewToPresenterImageListScreenProtocol: class {
    var view: PresenterToViewImageListScreenProtocol? { get set }
    var interactor: PresenterToInteractorImageListScreenProtocol? { get set }
    var router: PresenterToRouterImageListScreenProtocol? { get set }
    var currentCountOfUnsplashImageDetailsFetched: Int { get }
    var totalCountOfPages: Int { get }
    
    /// Notifies the presenter to fetch the data to update the view.
    /// - Parameter page: An `Int` representing the page of the result to be loaded.
    /// - Parameter hasScreenRefreshed: A `Bool` value indicating whether the user has performed the swipe-to-refresh action in the Image List Screen.
    func updateView(withPage page: Int, hasScreenRefreshed: Bool)
    
    
    /// Used to fetch the `UnsplashImageDetails` at a particular index.
    ///
    /// If the index is out-of-bounds, an empty `UnsplashImageDetails` object would be returned instead of nil, to prevent app crashes.
    /// - Parameter index: An `Int` denoting the index whose `UnsplashImageDetails` have to be fetched.
    /// - Returns: The `UnsplashImageDetails` object at the specified index.
    func fetchUnsplashImageDetails(atIndex index: Int) -> UnsplashImageDetails
    
    
    /// Used to redirect the user to the Image Details screen, when the user taps / selects an image in the Image List Screen.
    /// - Parameters:
    ///   - index: An `int` denoting the index of the cell which was selected by the user in the Image List Screen.
    func pushToImageDetailsScreen(selectedCellIndex index: Int)
}

protocol PresenterToViewImageListScreenProtocol: class {
    /// Notifies the view to show images.
    func showImages()
    
    
    /// Notifies the view to show an error.
    func showError()
}

protocol PresenterToRouterImageListScreenProtocol: class {
    /// This method creates the Images List Screen module by initializing the view, presenter and interactor which would be used to display data in the Images List Screen.
    /// - Returns: A `UINavigationController` above which the subsequent screens of the app can be pushed.
    static func createModule() -> UINavigationController
    
    
    /// This method pushes the user to the Details Screen, where the entire image is loaded, and other relevant details are also displayed.
    /// - Parameters:
    ///   - blurHash: A `String` representing the blurHash of the image. This will be used to show the placeholder of the image, while the full raw image is being fetched in the background.
    ///   - fullImageURL: A `String` representing the URL of the full image with its maximum dimensions ( as opposed to regular, small or thummnail image URLs ).
    ///   - location: A `String` representing the location.
    ///   - imageDescriptionn: A `String` representing the description of the image.
    ///   - profileImageURL: A `String` representing the user's profile image URL.
    ///   - name: A `String` representing the name ( or the Unsplash username ) of the user.
    func pushToDetailsScreen(withBlurHash blurHash: String,
                             withURL fullImageURL: String,
                             withLocation location: String,
                             withImageDescription imageDescriptionn: String,
                             withProfileImageURL profileImageURL: String,
                             withUserName name: String)
}

protocol PresenterToInteractorImageListScreenProtocol: class {
    var presenter: InteractorToPresenterImageListScreenProtocol? { get set }
    
    /// Notifies the interactor to fetch a page of image results.
    /// - Parameter page: An `Int` denoting the page of the results to be fetched.
    func loadRandomImages(withPage page: Int)
}

protocol InteractorToPresenterImageListScreenProtocol: class {
    /// This method is used to return the list of `UnsplashImageDetails` to the presenter.
    /// - Parameter unsplashImageDetailsList: An array of `UnsplashImageDetails`.
    func onImagesFetched(unsplashImageDetailsList: [UnsplashImageDetails], linkHeaderValue: String?)
    
    
    /// This method is used to return an `Error` to the presenter, in case the API call gave an error.
    /// - Parameter error: An `Error`.
    func onImagesFetchError(error: Error)
}
