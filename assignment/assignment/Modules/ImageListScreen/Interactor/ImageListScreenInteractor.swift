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
        let localTesting = true // This variable will be removed later. It is added only for local testing
        if localTesting {
            if page == 1 {
                if let url = Bundle.main.url(forResource: "response", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let unsplashImageDetailsList = try decoder.decode([UnsplashImageDetails].self, from: data)
                        self.presenter?.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList, linkHeaderValue: "")
                    } catch {
                        print("Error! Unable to parse response.json")
                    }
                }
            }
            else if page == 2 {
                if let url = Bundle.main.url(forResource: "response_page2", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let unsplashImageDetailsList = try decoder.decode([UnsplashImageDetails].self, from: data)
                        self.presenter?.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList, linkHeaderValue: "")
                    } catch {
                        print("Error! Unable to parse response_page2.json")
                    }
                }
            } else {
                if let url = Bundle.main.url(forResource: "response_page3", withExtension: "json") {
                    do {
                        let data = try Data(contentsOf: url)
                        let decoder = JSONDecoder()
                        let unsplashImageDetailsList = try decoder.decode([UnsplashImageDetails].self, from: data)
                        self.presenter?.onImagesFetched(unsplashImageDetailsList: unsplashImageDetailsList, linkHeaderValue: "")
                    } catch {
                        print("Error! Unable to parse response_page3.json")
                    }
                }
            }
        } else {
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
}
