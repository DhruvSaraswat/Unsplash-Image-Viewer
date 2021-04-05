//
//  Utility.swift
//  assignmentTests
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

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
}
