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
    private let refreshControl = UIRefreshControl()
    var loadingView: LoadingIndicatorView?
    var isLoading = false
    var hasErrorOccurredWhileFetchingImageList = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currentPage = 1
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        imageCollectionView.prefetchDataSource = self
        imageCollectionView.backgroundColor = .clear
        
        refreshControl.addTarget(self, action: #selector(refreshImages), for: .valueChanged)
        imageCollectionView.refreshControl = refreshControl // for swipe-to-refresh user action.
        
        imageCollectionView.register(UINib(nibName: "ImageListScreenCollectionViewCell", bundle: nil),
                                     forCellWithReuseIdentifier: ImageListScreenCollectionViewCell.reuseIdentifier)
        
        imageCollectionView.register(UINib(nibName: "LoadingIndicatorView", bundle: nil),
                                     forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                     withReuseIdentifier: LoadingIndicatorView.reuseIdentifier)
        
        presenter?.updateView(withPage: currentPage ?? 1, hasScreenRefreshed: false)
    }
    
    @objc func refreshImages() {
        currentPage = 1 // reset current page to 1
        presenter?.updateView(withPage: currentPage ?? 1, hasScreenRefreshed: true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // When the device rotates, invalidate the layout of the imageCollectionView so that the cells resize appropriately.
        imageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
}

extension ImageListScreenViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSourcePrefetching {
    // MARK: UICollectionViewDataSourcePrefetching
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            let unsplashImageDetails = presenter?.fetchUnsplashImageDetails(atIndex: indexPath.row)
            
            /// Start loading the image and the user's profile image asynchronously and store it in cache, so that when the cell appears in the viewport of the device, the images would already be downloaded / downloading would be in progress.
            /// This makes for a smooth scrolling experience with no lag.
            if let imageURL = URL(string: unsplashImageDetails?.urls?.regular ?? "") {
                NetworkLayer.sharedInstance.loadImage(from: imageURL)
            }
            if let userProfileImageURL = URL(string: unsplashImageDetails?.user?.profile_image?.medium ?? "") {
                NetworkLayer.sharedInstance.loadImage(from: userProfileImageURL)
            }
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
        
        if !unsplashImageCell.unsplashImageView.subviews.isEmpty {
            /// This prevents the dark overlay from getting added to any cells apart from the topmost (first) cell, since that same cell with the same subviews gets reused.
            for subview in unsplashImageCell.unsplashImageView.subviews {
                subview.removeFromSuperview()
            }
        }
        
        if indexPath.row == 0 {
            // Add a dark overlay on the first image displayed, and display the text "DOSPLASH" on top of it.
            unsplashImageCell.darkOverlay.isHidden = false
            unsplashImageCell.dosplashLabel.isHidden = false
        }
        
        unsplashImageCell.tag = indexPath.row
        
        unsplashImageCell.unsplashImageView.image = UIImage(blurHash: unsplashImageDetails?.blur_hash ?? "", size: CGSize(width: 20, height: 20))
        unsplashImageCell.unsplashImageView.addSpinner()
        
        NetworkLayer.sharedInstance.loadImage(from: imageURL) { (loadedImage) in
            guard let image = loadedImage else {
                return
            }
            DispatchQueue.main.async {
                if unsplashImageCell.tag == indexPath.row {
                    unsplashImageCell.unsplashImageView.removeSpinner()
                    unsplashImageCell.unsplashImageView.image = image
                }
            }
        }
        
        if indexPath.row != 0 {
            unsplashImageCell.unsplashUserProfileImageView.isHidden = false
            unsplashImageCell.unsplashUserProfileImageView.addSpinner()
            if let userProfileImageURL = URL(string: unsplashImageDetails?.user?.profile_image?.medium ?? "") {
                NetworkLayer.sharedInstance.loadImage(from: userProfileImageURL) { (loadedImage) in
                    guard let image = loadedImage else {
                        return
                    }
                    DispatchQueue.main.async {
                        if unsplashImageCell.tag == indexPath.row {
                            unsplashImageCell.unsplashUserProfileImageView.removeSpinner()
                            unsplashImageCell.unsplashUserProfileImageView.image = image
                        }
                    }
                }
            }
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
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (currentPage ?? 1) < (presenter?.totalCountOfPages ?? 1) {
            if (indexPath.row >= ((presenter?.currentCountOfUnsplashImageDetailsFetched ?? 1) - 2)) && (!self.isLoading) {
                // Load new page data.
                self.isLoading = true
                presenter?.updateView(withPage: currentPage ?? 1, hasScreenRefreshed: false)
            }
        } else {
            // If the user has navigated to the end of the list, do not load any more pages.
            self.isLoading = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                   withReuseIdentifier: LoadingIndicatorView.reuseIdentifier,
                                                                   for: indexPath)
        
        guard let footerView = cell as? LoadingIndicatorView else {
            return cell
        }
        if kind == UICollectionView.elementKindSectionFooter {
            loadingView = footerView
            loadingView?.layer.borderColor = UIColor.clear.cgColor
            loadingView?.backgroundColor = UIColor.clear
            return footerView
        }
        return footerView
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicatorView.startAnimating()
            if hasErrorOccurredWhileFetchingImageList {
                self.loadingView?.activityIndicatorView.stopAnimating()
                self.loadingView?.activityIndicatorView.isHidden = true
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicatorView.stopAnimating()
            self.loadingView?.activityIndicatorView.isHidden = true
            self.loadingView?.endOfListLabel.isHidden = false
            self.imageCollectionView.collectionViewLayout.invalidateLayout()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        presenter?.pushToImageDetailsScreen(selectedCellIndex: indexPath.row)
    }
    
}

extension ImageListScreenViewController: PresenterToViewImageListScreenProtocol {
    func showImages() {
        self.currentPage! += 1
        self.hasErrorOccurredWhileFetchingImageList = false
        DispatchQueue.main.async {
            self.imageCollectionView.reloadData()
            if self.refreshControl.isRefreshing {
                self.refreshControl.endRefreshing()
            }
            self.isLoading = false
        }
    }
    
    func showError() {
        self.hasErrorOccurredWhileFetchingImageList = true
        showAlert(withTitle:"Error in Fetching Images",
                  withMessage: "An unexpected error occurred when fetching images, please try swiping down to reload and try again.")
        if self.refreshControl.isRefreshing {
            self.refreshControl.endRefreshing()
            self.imageCollectionView.contentOffset = CGPoint.zero
        }
        self.imageCollectionView.collectionViewLayout.invalidateLayout()
    }
    
    func calculatedScaledHeight(imageHeight: CGFloat, imageWidth: CGFloat, cellWidth: CGFloat) -> CGFloat {
        return cellWidth * imageHeight / imageWidth
    }
}
