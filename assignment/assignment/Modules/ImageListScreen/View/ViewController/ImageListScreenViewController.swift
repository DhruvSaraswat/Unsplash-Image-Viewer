//
//  ImageListScreenViewController.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import UIKit

class ImageListScreenViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var presenter: ViewToPresenterImageListScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageCollectionView.backgroundColor = .red
    }

}

extension ImageListScreenViewController: PresenterToViewImageListScreenProtocol {
    func showImages() {
        
    }
    
    func showError() {
        
    }
}
