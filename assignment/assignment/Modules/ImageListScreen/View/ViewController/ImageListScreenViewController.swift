//
//  ImageListScreenViewController.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import UIKit

class ImageListScreenViewController: UIViewController {

    @IBOutlet weak var imageCollectionView: UICollectionView!
    var currentPage: Int?
    var presenter: ViewToPresenterImageListScreenProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 1
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self
        imageCollectionView.backgroundColor = .clear
        
        imageCollectionView.register(UINib(nibName: "ImageListScreenCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: ImageListScreenCollectionViewCell.reuseIdentifier)
        
        presenter?.updateView(withPage: currentPage ?? 1)
    }

}

extension ImageListScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    // MARK: UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        let customImageView = CustomImageView()
        for indexPath in indexPaths {
            let unsplashImageDetails = presenter?.fetchUnsplashImageDetails(atIndex: indexPath.row)
            customImageView.loadImage(from: URL(string: unsplashImageDetails?.urls?.regular ?? "")!, blurHash: unsplashImageDetails?.blur_hash ?? "")
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter?.currentCountOfUnsplashImageDetailsFetched ?? 0
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: ImageListScreenCollectionViewCell.reuseIdentifier, for: indexPath)
        let unsplashImageDetails = presenter?.fetchUnsplashImageDetails(atIndex: indexPath.row)
        
        guard
            let unsplashImageCell = cell as? ImageListScreenCollectionViewCell,
            let imageURL = URL(string: unsplashImageDetails?.urls?.regular ?? "")
        else {
            return cell
        }
        
        if indexPath.row == 0 {
            // Set a dark overlay on the image, and display the Unsplash text.
        }
        
        unsplashImageCell.unsplashImageView.loadImage(from: imageURL, blurHash: unsplashImageDetails?.blur_hash ?? "")
        
        if let userProfileImageURL = URL(string: unsplashImageDetails?.user?.profile_image?.medium ?? "") {
            unsplashImageCell.unsplashUserProfileImageView.loadImage(from: userProfileImageURL, blurHash: "")
        }
        return unsplashImageCell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let unsplashImageDetails = presenter?.fetchUnsplashImageDetails(atIndex: indexPath.row)
        let height = calculatedScaledHeight(imageHeight: CGFloat(unsplashImageDetails?.height ?? 0),
                                            imageWidth: CGFloat(unsplashImageDetails?.width ?? 0),
                                            cellWidth: imageCollectionView.frame.width)
        return CGSize(width: imageCollectionView.frame.width, height: height)
    }
    
}

extension ImageListScreenViewController: PresenterToViewImageListScreenProtocol {
    func showImages() {
        self.currentPage! += 1
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
        }
    }
    
    func showError() {
        
    }
    
    func calculatedScaledHeight(imageHeight: CGFloat, imageWidth: CGFloat, cellWidth: CGFloat) -> CGFloat {
        return cellWidth * imageHeight / imageWidth
    }
}
