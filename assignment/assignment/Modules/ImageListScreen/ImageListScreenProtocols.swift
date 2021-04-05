//
//  ImageListScreenProtocols.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 05/04/21.
//

protocol ViewToPresenterImageListScreenProtocol: class {
    /// Notifies the presenter to fetch the data to update the view.
    /// - Parameter page: An `Int` representing the page of the result to be loaded.
    func updateView(withPage page: Int)
}

protocol PresenterToViewImageListScreenProtocol: class {
    /// Notifies the view to show images.
    func showImages()
}

protocol PresenterToRouterImageListScreenProtocol: class {
    /// This method pushes the user to the Details Screen, where the entire image is loaded.
    /// - Parameters:
    ///   - blurHash: A `String` representing the blurHash of the image. This will be used to show the placeholder of the image, while the full raw image is being fetched in the background.
    ///   - rawImageURL: A `String` representing the raw URL of the image.
    ///   - imageWidth: An `Int` representing the width of the image.
    ///   - imageHeight: An `Int` representing the height of the image.
    func pushToDetailsScreen(withBlurHash blurHash: String,
                             withURL rawImageURL: String,
                             withImageWidth imageWidth: Int,
                             withImageHeight imageHeight: Int)
}

protocol PresenterToInteractorImageListScreenProtocol: class {
    /// Notifies the interactor to fetch a page of image results.
    /// - Parameter page: An `Int` denoting the page of the results to be fetched.
    func loadRandomImages(withPage page: Int)
}

protocol InteractorToPresenterImageListScreenProtocol: class {
    /// This method is used to return the list of `UnsplashImageDetails` to the presenter.
    /// - Parameter unsplashImageDetailsList: An array of `UnsplashImageDetails`.
    func onImagesFetched(unsplashImageDetailsList: [UnsplashImageDetails])
    
    
    /// This method is used to return an `Error` to the presenter, in case the API call gave an error.
    /// - Parameter error: An `Error`.
    func onImagesFetchError(error: Error)
}
