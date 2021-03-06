//
//  ImageListScreenInteractor.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import UIKit
class ImageListScreenInteractor: PresenterToInteractorImageListScreenProtocol {
    
    weak var presenter: InteractorToPresenterImageListScreenProtocol?
    var networkLayer: NetworkLayer!
    
    /// An initializer for `ImageListScreenInteractor`.
    /// - Parameter networkLayer: A `NetworkLayer` object.
    init(networkLayer: NetworkLayer = NetworkLayer()) {
        self.networkLayer = networkLayer
    }
    
    func loadRandomImages(withPage page: Int) {
        self.networkLayer.loadRandomImages(withPage: page, resultsPerPage: 10) { (result, linkHeaderValue) in
            switch result {
            case .success(let unsplashImageDetailsList):
                self.presenter?.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList, linkHeaderValue: linkHeaderValue)
                
            case .failure(let error):
                self.presenter?.onImagesFetchError(error: error)
            }
        }
    }
}
