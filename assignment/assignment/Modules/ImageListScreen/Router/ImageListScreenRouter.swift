//
//  ImagesListScreenRouter.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import UIKit

class ImageListScreenRouter: PresenterToRouterImageListScreenProtocol {
    
    static func createModule() -> UINavigationController {
        let imageListScreenViewController = ImageListScreenViewController(nibName: "ImageListScreenViewController", bundle: nil)
        let navigationController = UINavigationController(rootViewController: imageListScreenViewController)
        
        let presenter: ViewToPresenterImageListScreenProtocol & InteractorToPresenterImageListScreenProtocol = ImageListScreenPresenter()
        let interactor: PresenterToInteractorImageListScreenProtocol = ImageListScreenInteractor()
        let router: PresenterToRouterImageListScreenProtocol = ImageListScreenRouter()
        
        imageListScreenViewController.presenter = presenter
        imageListScreenViewController.presenter?.view = imageListScreenViewController
        imageListScreenViewController.presenter?.router = router
        imageListScreenViewController.presenter?.interactor = interactor
        imageListScreenViewController.presenter?.interactor?.presenter = presenter
        
        return navigationController
    }
    
    func pushToDetailsScreen(withBlurHash blurHash: String, withURL rawImageURL: String, withImageWidth imageWidth: Int, withImageHeight imageHeight: Int) {
        
    }
}
