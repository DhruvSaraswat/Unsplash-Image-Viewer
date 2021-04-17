//
//  CustomImageView.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 17/04/21.
//

import UIKit

let imageCache = NSCache<NSURL, UIImage>()
class CustomImageView: UIImageView {
    
    var task: URLSessionDataTask!
    let spinner = UIActivityIndicatorView(style: .medium)
    
    func loadImage(from url: URL, blurHash: String, forIndex: Int, completion: ((_ loadedImage: UIImage) -> Void)? = nil) {
        
        // Assign nil to the image, to fix the flickering issue.
        image = nil
        
        addSpinner()
        
        if let task = task {
            task.cancel()
        }
        
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            removeSpinner()
            if let completion = completion {
                completion(imageFromCache)
            }
            return
        }
        
        // Set the placeholder image using the blurHash value, while the actual image is being fetched.
        if !blurHash.isEmpty {
            self.image = UIImage(blurHash: blurHash, size: CGSize(width: 20, height: 20))
        }
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let loadedImage = UIImage(data: data)
            else {
                print("Counldn't load image from url = \(url)")
                return
            }
            
            imageCache.setObject(loadedImage, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                self.removeSpinner()
                if let completion = completion {
                    completion(loadedImage)
                }
            }
        }
        task.resume()
    }
    
    func addSpinner() {
        addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        spinner.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        spinner.startAnimating()
    }
    
    func removeSpinner() {
        spinner.removeFromSuperview()
    }
    
}
