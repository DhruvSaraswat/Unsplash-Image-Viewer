//
//  ImageListScreenInteractor.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

class ImageListScreenInteractor: PresenterToInteractorImageListScreenProtocol {
    
    weak var presenter: InteractorToPresenterImageListScreenProtocol?
    var networkLayer: NetworkLayer!
    
    /// An initializer for `ImageListScreenInteractor`.
    /// - Parameter networkLayer: A `NetworkLayer` object.
    init(networkLayer: NetworkLayer = NetworkLayer()) {
        self.networkLayer = networkLayer
    }
    
    func loadRandomImages(withPage page: Int) {
        
    }
}
