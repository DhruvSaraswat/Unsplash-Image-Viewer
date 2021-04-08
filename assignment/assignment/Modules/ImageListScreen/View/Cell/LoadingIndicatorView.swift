//
//  LoadingIndicatorView.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 08/04/21.
//

import UIKit

class LoadingIndicatorView: UICollectionReusableView {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        activityIndicatorView.color = .black
    }
    
}
