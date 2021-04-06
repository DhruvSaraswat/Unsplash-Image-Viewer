//
//  APIResponseModels.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 05/04/21.
//

/// Used to model the image details returned by Unsplash APIs.
struct UnsplashImageDetails: Codable {
    /// An `Int` denoting the width of the image.
    var width: Int?
    
    /// An `Int` denoting the height of the image.
    var height: Int?
    
    /// A `String` denoting the blurHash String representation of the image. This can be used to show a placeholder image while the actual image is being fetched in the background.
    var blur_hash: String?
    
    /// A `String` denoting the description of the image.
    var description: String?
    
    /// A `String` denoting the alternate description of the image.
    var alt_description: String?
    
    /// An `UnsplashImageURLs` object.
    var urls: UnsplashImageURLs?
    
    /// An `UnsplashUserDetails` object.
    var user: UnsplashUserDetails?
}


/// Used to model the Image URLs returned by Unsplash APIs. For more details, refer the [example image use section in the Unsplash API documentation](https://unsplash.com/documentation#example-image-use).
struct UnsplashImageURLs: Codable {
    /// A `String` representing the base image URL with just the photo path and the ixid parameter. Use this to easily add additional image parameters to construct our own image URL.
    var raw: String?
    
    /// A `String` representing the URL of the photo in jpg format with its maximum dimensions.
    var full: String?
    
    /// A `String` representing the URL of the photo in jpg format with a width of 1080 pixels.
    var regular: String?
    
    /// A `String` representing the URL of the photo in jpg format with a width of 400 pixels.
    var small: String?
    
    /// A `String` representing the URL of the photo in jpg format with a width of 200 pixels.
    var thumb: String?
}


/// Used to model the Unsplash user details returned by Unsplash APIs.
struct UnsplashUserDetails: Codable {
    /// A `String` representing the Unsplash username of the user.
    var username: String?
    
    /// A `String` representing the name of the Unsplash user.
    var name: String?
    
    /// A `String` representing the location of the Unsplash user.
    var location: String?
    
    /// An `UnsplashUserProfileImageURLs` object.
    var profile_image: UnsplashUserProfileImageURLs?
}

/// Used to model the profile image URLs of the Unsplash users returned by Unsplash APIs.
struct UnsplashUserProfileImageURLs: Codable {
    /// A `String` representing the URL of a small-sized photo of the user's profile image.
    var small: String?
    
    /// A `String` representing the URL of a medium-sized photo of the user's profile image.
    var medium: String?
    
    /// A `String` representing the URL of a large-sized photo of the user's profile image.
    var large: String?
}
