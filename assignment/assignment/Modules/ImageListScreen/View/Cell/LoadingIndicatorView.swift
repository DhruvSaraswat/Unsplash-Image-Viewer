//
//  LoadingIndicatorView.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 08/04/21.
//

import UIKit

class LoadingIndicatorView: UICollectionReusableView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    static let reuseIdentifier = "LoadingIndicatorView"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.color = .black
    }
    
}
