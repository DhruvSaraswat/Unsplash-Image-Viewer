//
//  ImageListScreenCollectionViewCell.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import UIKit

class ImageListScreenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var unsplashImageView: CustomImageView!
    @IBOutlet weak var unsplashUserProfileImageView: CustomImageView!
    @IBOutlet weak var dosplashLabel: UILabel!
    @IBOutlet weak var darkOverlay: UIView!
    static let reuseIdentifier = "ImageListScreenCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Make the User profile image circular.
        self.unsplashUserProfileImageView.layer.masksToBounds = false
        self.unsplashUserProfileImageView.layer.borderWidth = 2.5
        self.unsplashUserProfileImageView.layer.borderColor = UIColor.white.cgColor
        self.unsplashUserProfileImageView.layer.cornerRadius = self.unsplashUserProfileImageView.frame.height / 2
        self.unsplashUserProfileImageView.clipsToBounds = true
        
        // Put the dosplashLabel label on top.
        self.dosplashLabel.layer.zPosition = 1
        
        // Scale the font size of the dosplashLabel for different screen sizes.
        self.dosplashLabel.font = UIFont.systemFont(ofSize: self.frame.size.height * 60 / 400)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.dosplashLabel.isHidden = true
        self.darkOverlay.isHidden = true
        self.unsplashUserProfileImageView.isHidden = true
    }

}
