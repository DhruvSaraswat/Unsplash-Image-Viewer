//
//  ImageCache.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 18/04/21.
//

import UIKit

protocol ImageCacheProtocol {
    /// Stores a `UIImage` in cache with its key as the `URL` from where it was loaded, so that it can be retrieved later without performing a network request.
    /// - Parameters:
    ///   - image: The `UIImage` which has to be stored in cache
    ///   - url: The `URL` from which the image has been loaded. This will be used as the key (after type-casting it to `NSURL`) to store the `UIImage`.
    func storeImage(image: UIImage, for url: URL)
    
    /// Retrieves a `UIImage` from cache, given the `URL` which was used as key to store it in cache.
    /// - Parameter url: The `URL` whose `UIImage` has to be retrieved from cache.
    /// - Returns: An optional `UIImage` stored for the given `URL`.
    func retrieveImage(for url: URL) -> UIImage?
}

class ImageCache: ImageCacheProtocol {
    
    private let imageCache = NSCache<NSURL, UIImage>()
    public static let sharedInstance = ImageCache()
    
    func storeImage(image: UIImage, for url: URL) {
        imageCache.setObject(image, forKey: url as NSURL)
    }
    
    func retrieveImage(for url: URL) -> UIImage? {
        return imageCache.object(forKey: url as NSURL)
    }
    
}
