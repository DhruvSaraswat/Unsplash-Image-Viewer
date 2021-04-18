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
    
    
    /// This method cancels a download task for the given URL, if it exists.
    /// - Parameter url: The `URL` whose download task has to be cancelled.
    func cancelDownload(for url: URL)
}

class NetworkLayer: NetworkLayerProtocol {
    
    let urlSession: URLSession
    let clientID: String
    public static let sharedInstance = NetworkLayer()
    private let imageCache: ImageCache
    private var tasks = [URL: URLSessionDataTask]()
    
    /// Create an instance of `NetworkLayer` to carry out API calls and Network requests.
    /// - Parameter urlSession: A `URLSession` object. Default value is `URLSession.shared`.
    /// - Parameter clientID: A `String` containing the value of the clientID.
    /// - Parameter imageCache: An `ImageCache` object. Default value is `ImageCache.sharedInstance`.
    init(urlSession: URLSession = URLSession.shared,
         clientID: String = AppConfig.sharedInstance.getUnsplashAPIKey(),
         imageCache: ImageCache = ImageCache.sharedInstance) {
        self.urlSession = urlSession
        self.clientID = clientID
        self.imageCache = imageCache
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
        if let imageFromCache = self.imageCache.retrieveImage(for: url) {
            if let completion = completion {
                self.tasks.removeValue(forKey: url)
                completion(imageFromCache)
            }
            return
        }
        
        let task = self.urlSession.dataTask(with: url) { (data, response, error) in
            guard
                let data = data,
                let loadedImage = UIImage(data: data)
            else {
                print("Counldn't load image from url = \(url)")
                if let completion = completion {
                    self.tasks.removeValue(forKey: url)
                    completion(nil)
                }
                return
            }
            
            self.imageCache.storeImage(image: loadedImage, for: url)
            
            DispatchQueue.main.async {
                if let completion = completion {
                    self.tasks.removeValue(forKey: url)
                    completion(loadedImage)
                }
            }
        }
        tasks[url] = task
        task.resume()
    }
    
    func cancelDownload(for url: URL) {
        if let downloadTask = tasks[url] {
            downloadTask.cancel()
            self.tasks.removeValue(forKey: url)
        }
    }
}
