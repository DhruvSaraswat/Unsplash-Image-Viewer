//
//  Utility.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

@testable import assignment

/// This class contains utility methods which can be used throughout the unit test modulle of this project.
class Utility {
    /// A `static` utility method which returns an alphanumeric `String` containing the specified number of characters.
    ///
    /// The returned `String` would contain uppercase English alphabets [A-Z], lowercase English alphabets [a-z] or digits `0-9`.
    /// If the length is less than or equal to `0`, an empty `String` of length `0` would be returned.
    ///
    /// - Parameter length: An `Int` denoting the number of characters the randomly generated `String` should have.
    /// - Returns: An alphanumeric `String` containing the specified number of characters.
    static func generateAlphanumericString(length: Int) -> String {
        if length <= 0 {
            return ""
        }
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map{ _ in letters.randomElement()! })
    }
    
    
    /// A `static` utility method which generates a random integer between lowerBound ( inclusive ) and upperBound ( exclusive ).
    ///
    /// If the lower bound is greater than or equal to the upper bound provided, `nil` would be returned.
    ///
    /// - Parameters:
    ///   - lowerBound: An `Int` denoting the lower bound of the integer to be generated.
    ///   - upperBound: An `Int` denoting the upper bound of the integer to be generated.
    /// - Returns: An `Int` between lowerBound ( inclusive ) and upperBound ( exclusive ).
    static func generateRandomPositiveInteger(inclusive lowerBound: Int, exclusive upperBound: Int) -> Int? {
        if lowerBound >= upperBound {
            return nil
        }
        return Int.random(in: lowerBound..<upperBound)
    }
    
    
    /// A `static` utility method which returns an `UnsplashImageDetails` object populated with random values.
    /// - Returns: An `UnsplashImageDetails` object populated with random values.
    static func generateRandomUnsplashImageDetails() -> UnsplashImageDetails {
        var unsplashImageDetails = UnsplashImageDetails()
        unsplashImageDetails.blur_hash = generateAlphanumericString(length: 10)
        unsplashImageDetails.height = generateRandomPositiveInteger(inclusive: 10, exclusive: 100)
        unsplashImageDetails.urls = generateRandomUnsplashImageURLs()
        unsplashImageDetails.user = generateRandomUnsplashUserDetails()
        unsplashImageDetails.width = generateRandomPositiveInteger(inclusive: 10, exclusive: 100)
        return unsplashImageDetails
    }
    
    
    /// A `static` utility method which returns an `UnsplashImageURLs` object populated with random values.
    /// - Returns: An `UnsplashImageURLs` object populated with random values.
    static func generateRandomUnsplashImageURLs() -> UnsplashImageURLs {
        var unsplashImageURLs = UnsplashImageURLs()
        unsplashImageURLs.full = generateAlphanumericString(length: 10)
        unsplashImageURLs.raw = generateAlphanumericString(length: 10)
        unsplashImageURLs.regular = generateAlphanumericString(length: 10)
        unsplashImageURLs.small = generateAlphanumericString(length: 10)
        unsplashImageURLs.thumb = generateAlphanumericString(length: 10)
        return unsplashImageURLs
    }
    
    
    /// A `static` utility method which returns an `UnsplashUserDetails` object populated with random values.
    /// - Returns: An `UnsplashUserDetails` object populated with random values.
    static func generateRandomUnsplashUserDetails() -> UnsplashUserDetails {
        var unsplashUserDetails = UnsplashUserDetails()
        unsplashUserDetails.profile_image = generateRandomUnsplashUserProfileImageURLs()
        return unsplashUserDetails
    }
    
    
    /// A `static` utility method which returns an `UnsplashUserProfileImageURLs` object populated with random values.
    /// - Returns: An `UnsplashUserProfileImageURLs` object populated with random values.
    static func generateRandomUnsplashUserProfileImageURLs() -> UnsplashUserProfileImageURLs {
        var unsplashUserProfileImageURLs = UnsplashUserProfileImageURLs()
        unsplashUserProfileImageURLs.large = generateAlphanumericString(length: 10)
        unsplashUserProfileImageURLs.medium = generateAlphanumericString(length: 10)
        unsplashUserProfileImageURLs.small = generateAlphanumericString(length: 10)
        return unsplashUserProfileImageURLs
    }
}
