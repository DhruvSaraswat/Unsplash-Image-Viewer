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
    
    var currentCountOfUnsplashImageDetailsFetched: Int {
        return currentlyDisplayedUnsplashImageDetailsList?.count ?? 0
    }
    
    var totalCountOfPages: Int
    
    init(_ unsplashImageDetailsList: [UnsplashImageDetails] = [UnsplashImageDetails]()) {
        self.currentlyDisplayedUnsplashImageDetailsList = unsplashImageDetailsList
        self.totalCountOfPages = 1
    }
    
    func updateView(withPage page: Int, hasScreenRefreshed: Bool) {
        if hasScreenRefreshed {
            currentlyDisplayedUnsplashImageDetailsList?.removeAll()
        }
        interactor?.loadRandomImages(withPage: page)
    }
    
    func fetchUnsplashImageDetails(atIndex index: Int) -> UnsplashImageDetails {
        return ((index < 0) || (index >= currentCountOfUnsplashImageDetailsFetched)) ? UnsplashImageDetails() : currentlyDisplayedUnsplashImageDetailsList![index]
    }
    
    func pushToImageDetailsScreen(selectedCellIndex index: Int) {
        router?.pushToDetailsScreen(fromScreen: view!, withUnsplashImageDetails: currentlyDisplayedUnsplashImageDetailsList?[index] ?? UnsplashImageDetails())
    }
}

extension ImageListScreenPresenter: InteractorToPresenterImageListScreenProtocol {
    func onImagesFetched(unsplashImageDetailsList: [UnsplashImageDetails], linkHeaderValue: String?) {
        if (linkHeaderValue != nil) && (!(linkHeaderValue?.isEmpty ?? true)) {
            totalCountOfPages = extractTotalNumberOfPages(fromLinkHeader: linkHeaderValue ?? "")
        }
        self.currentlyDisplayedUnsplashImageDetailsList?.append(contentsOf: unsplashImageDetailsList)
        view?.showImages()
    }
    
    func onImagesFetchError(error: Error) {
        view?.showError()
    }
    
    private func extractTotalNumberOfPages(fromLinkHeader linkHeader: String) -> Int {
        var extractedValue = 1
        if let range = linkHeader.range(of: "&page="), let range2 = linkHeader.range(of: "&per_page=") {
            extractedValue = Int(linkHeader[range.upperBound..<range2.lowerBound]) ?? 1
        }
        return extractedValue
    }
}
