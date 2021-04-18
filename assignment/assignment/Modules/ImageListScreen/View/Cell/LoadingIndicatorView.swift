//
//  LoadingIndicatorView.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 08/04/21.
//

import UIKit

class LoadingIndicatorView: UICollectionReusableView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var endOfListLabel: UILabel!
    static let reuseIdentifier = "LoadingIndicatorView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.color = .black
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Scale the font size of the dosplashLabel for different screen sizes.
        self.endOfListLabel.font = UIFont.systemFont(ofSize: self.frame.size.height * 70 / 400)
    }
    
}
