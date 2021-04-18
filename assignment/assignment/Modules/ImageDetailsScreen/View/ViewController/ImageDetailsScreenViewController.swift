//
//  ImageDetailsScreenViewController.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 18/04/21.
//

import UIKit

class ImageDetailsScreenViewController: UIViewController {
    
    var unsplashImageDetails: UnsplashImageDetails?
    let imageActivityIndicatorView = UIActivityIndicatorView(style: .medium)
    let userProfileImageActivityIndicatorView = UIActivityIndicatorView()
    var isImageLoaded = false
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageDescriptionLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var closeButtonIcon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        
        setupViews()
        setImage()
        setUserProfileImage()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        imageView.contentMode = .scaleAspectFill
        userProfileImageView.clipsToBounds = true
        userProfileImageView.contentMode = .scaleAspectFill
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
    }
    
    @objc func closeButtonTapped() {
        if !self.isImageLoaded {
            /// If the full-sized image has not completed loading yet and the user clicks on the close button, cancel that request to save network bandwidth.
            guard let fullImageURL = URL(string: unsplashImageDetails?.urls?.full ?? "") else { return }
            NetworkLayer.sharedInstance.cancelDownload(for: fullImageURL)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func calculatedScaledHeight(imageHeight: Int, imageWidth: Int, screenWidth: CGFloat) -> CGFloat {
        return screenWidth * CGFloat(imageHeight) / CGFloat(imageWidth)
    }
    
    func setupViews() {
        closeButtonIcon.layer.zPosition = 1
        
        imageHeightConstraint.constant = calculatedScaledHeight(imageHeight: unsplashImageDetails?.height ?? 0,
                                                                imageWidth: unsplashImageDetails?.width ?? 0,
                                                                screenWidth: self.view.frame.size.width)
        
        imageView.addSubview(imageActivityIndicatorView)
        imageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        imageActivityIndicatorView.color = .black
        imageActivityIndicatorView.centerXAnchor.constraint(equalTo: imageView.centerXAnchor).isActive = true
        imageActivityIndicatorView.centerYAnchor.constraint(equalTo: imageView.centerYAnchor).isActive = true
        
        userProfileImageView.addSubview(userProfileImageActivityIndicatorView)
        userProfileImageActivityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        userProfileImageActivityIndicatorView.color = .black
        userProfileImageActivityIndicatorView.centerXAnchor.constraint(equalTo: userProfileImageView.centerXAnchor).isActive = true
        userProfileImageActivityIndicatorView.centerYAnchor.constraint(equalTo: userProfileImageView.centerYAnchor).isActive = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeButtonTapped))
        closeButtonIcon.isUserInteractionEnabled = true
        closeButtonIcon.addGestureRecognizer(tapGestureRecognizer)
        
        imageDescriptionLabel.numberOfLines = 0
        imageDescriptionLabel.text = unsplashImageDetails?.description ?? unsplashImageDetails?.alt_description ?? "Image description not available"
        locationLabel.text = unsplashImageDetails?.user?.location ?? "Location not available"
        usernameLabel.text = unsplashImageDetails?.user?.username ?? unsplashImageDetails?.user?.name ?? "Name not available"
    }
    
    func setImage() {
        imageActivityIndicatorView.startAnimating()
        if let blurHash = unsplashImageDetails?.blur_hash {
            /// Set the image as the blurHash image while the full image is being fetched.
            imageView.image = UIImage(blurHash: blurHash, size: CGSize(width: 20, height: 20))
        }
        
        if let regularImageURL = URL(string: unsplashImageDetails?.urls?.regular ?? ""),
           let imageFromCache = ImageCache.sharedInstance.retrieveImage(for: regularImageURL) {
            /// If the regular-sized image has already been fetched and stored in cache from the previous Image List screen, set that as the image while the full image is being fetched.
            imageView.image = imageFromCache
        }
        
        if let fullImageURL = URL(string: unsplashImageDetails?.urls?.full ?? "") {
            NetworkLayer.sharedInstance.loadImage(from: fullImageURL) { (loadedImage) in
                guard let image = loadedImage else { return }
                DispatchQueue.main.async {
                    self.isImageLoaded = true
                    self.imageActivityIndicatorView.stopAnimating()
                    self.imageView.image = image
                }
            }
        }
    }
    
    func setUserProfileImage() {
        userProfileImageActivityIndicatorView.startAnimating()
        if let userProfileImage = URL(string: unsplashImageDetails?.user?.profile_image?.medium ?? "") {
            NetworkLayer.sharedInstance.loadImage(from: userProfileImage) { (loadedImage) in
                guard let image = loadedImage else { return }
                DispatchQueue.main.async {
                    self.userProfileImageActivityIndicatorView.stopAnimating()
                    self.userProfileImageView.image = image
                }
            }
        }
    }
    
}
