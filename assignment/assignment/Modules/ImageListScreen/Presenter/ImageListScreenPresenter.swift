//
//  ImageListScreenPresenter.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

class ImageListScreenPresenter: ViewToPresenterImageListScreenProtocol {
    weak var view: PresenterToViewImageListScreenProtocol?
    var interactor: PresenterToInteractorImageListScreenProtocol?
    var router: PresenterToRouterImageListScreenProtocol?
    
    /// To keep track of all the Unsplash Images which have been shown to the user in the Image List Screen till now.
    private var currentlyDisplayedUnsplashImageDetailsList: [UnsplashImageDetails]?
    
    var currentCountOfUnsplashImageDetailsDisplayed: Int {
        return currentlyDisplayedUnsplashImageDetailsList?.count ?? 0
    }
    
    init(_ unsplashImageDetailsList: [UnsplashImageDetails] = [UnsplashImageDetails]()) {
        self.currentlyDisplayedUnsplashImageDetailsList = unsplashImageDetailsList
    }
    
    func updateView(withPage page: Int) {
        interactor?.loadRandomImages(withPage: page)
    }
    
    func fetchUnsplashImageDetails(atIndex index: Int) -> UnsplashImageDetails {
        return ((index < 0) || (index >= currentCountOfUnsplashImageDetailsDisplayed)) ? UnsplashImageDetails() : currentlyDisplayedUnsplashImageDetailsList![index]
    }
}

extension ImageListScreenPresenter: InteractorToPresenterImageListScreenProtocol {
    func onImagesFetched(unsplashImageDetailsList: [UnsplashImageDetails]) {
        self.currentlyDisplayedUnsplashImageDetailsList?.append(contentsOf: unsplashImageDetailsList)
        view?.showImages()
    }
    
    func onImagesFetchError(error: Error) {
        view?.showError()
    }
}
