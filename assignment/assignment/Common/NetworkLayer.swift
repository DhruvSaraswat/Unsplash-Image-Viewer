//
//  NetworkLayer.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 05/04/21.
//

import UIKit

/// An `enum` denoting the different kinds of errors which can arise from Network calls.
enum Error: Swift.Error, CaseIterable {
    /// When the clientID is invalid.
    case invalidClientID
    
    /// When the API response is anything apart from the expected success response
    case unknownAPIResponse
    
    ///When there is an error in parsing the API response
    case unableToParseResponse
    
    case generic
}

protocol NetworkLayerProtocol {
    /// This method performs the actual [List Photos Unsplash API](https://unsplash.com/documentation#list-photos) call to fetch random images.
    ///
    /// This method internally adds the client_id to the HTTPS request to successfully authenticate Unsplash API calls.
    /// - Parameters:
    ///   - page: An `Int` denoting the page to be fetched. Default value is 1.
    ///   - resultsPerPage: An `Int` denoting the results per page to be fetched. Maximum value is 30 and default value is 10. Refer the [Pagination section in Unsplash API Documentation](https://unsplash.com/documentation#pagination).
    ///   - completion: A trailing closure which gets called with the `Result` of the [List Photos Unsplash API](https://unsplash.com/documentation#list-photos) call.
    func loadRandomImages(withPage page: Int, resultsPerPage: Int, completion: @escaping (Result<[UnsplashImageDetails], Error>, String?) -> Void)
    
    
    /// This method fetches an image from a `URL`, and then calls the optional completion handler with the resulting `UIImage`.
    ///
    /// Internally, this method first checks if the image from that URL is already stored in the cache, and only if it is not stored in the cache, it performs the HTTP(S) request, stores the image in cache and then calls the completion handler.
    /// - Parameters:
    ///   - url: A `URL` denonting the URL from which the image has to be loaded.
    ///   - completion: An optional trailing closure which gets called with the resulting `UIImage`.
    func loadImage(from url: URL, completion: ((_ loadedImage: UIImage?) -> Void)?)
}

class NetworkLayer: NetworkLayerProtocol {
    
    let urlSession: URLSession
    let clientID: String
    public static let sharedInstance = NetworkLayer()
    private let imageCache = NSCache<NSURL, UIImage>()
    
    /// Create an instance of `NetworkLayer` to carry out API calls and Network requests.
    /// - Parameter urlSession: A `URLSession` object. Default value is `URLSession.shared`.
    /// - Parameter clientID: A `String` containing the value of the clientID.
    init(urlSession: URLSession = URLSession.shared, clientID: String = AppConfig.sharedInstance.getUnsplashAPIKey()) {
        self.urlSession = urlSession
        self.clientID = clientID
    }
    
    func loadRandomImages(withPage page: Int = 1, resultsPerPage: Int = 10,
                          completion: @escaping (Result<[UnsplashImageDetails], Error>, String?) -> Void) {
        if clientID.isEmpty {
            completion(.failure(Error.invalidClientID), nil)
        }
        guard let url = URL(string: "https://api.unsplash.com/photos?client_id=\(clientID)&page=\(page)&per_page=\(resultsPerPage)")
        else { return }
        
        self.urlSession.dataTask(with: URLRequest(url: url)) { data, response, error in
            if let error = error {
                completion(.failure(error as! Error), nil)
                return
            }
            
            guard
                let httpResponse = (response as? HTTPURLResponse),
                httpResponse.statusCode == 200,
                let responseData = String(data: data!, encoding: String.Encoding.utf8) else {
                completion(.failure(Error.unknownAPIResponse), nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode([UnsplashImageDetails].self, from: Data(responseData.utf8))
                completion(.success(result), httpResponse.value(forHTTPHeaderField: "link"))
            } catch {
                completion(.failure(Error.unableToParseResponse), nil)
                return
            }
        }.resume()
    }
    
    func loadImage(from url: URL, completion: ((UIImage?) -> Void)? = nil) {
        if let imageFromCache = imageCache.object(forKey: url as NSURL) {
            if let completion = completion {
                completion(imageFromCache)
            }
            return
        }
        
        self.urlSession.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let loadedImage = UIImage(data: data)
            else {
                print("Counldn't load image from url = \(url)")
                if let completion = completion {
                    completion(nil)
                }
                return
            }
            
            self.imageCache.setObject(loadedImage, forKey: url as NSURL)
            
            DispatchQueue.main.async {
                if let completion = completion {
                    completion(loadedImage)
                }
            }
        }.resume()
    }
}
