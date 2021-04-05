//
//  AppConfig.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 06/04/21.
//

import Foundation

/// A utility class which can be used to fetch values ( constants ) stored in configuration files ( such as Info.plist ).
class AppConfig {
    
    private var envKeys: NSDictionary?
    
    /// A shared singleton instance of `AppConfig`.
    static let sharedInstance = AppConfig()
    
    
    /// A private initializer of `AppConfig`, so that only the singleton shared instance is used throughout the app, and the config file would not have to be loaded again-and-again.
    private init() {
        self.loadConfigFile()
    }
    
    
    /// Loads the Info.plist config file.
    private func loadConfigFile() {
        let infoPlist = Bundle.main.infoDictionary
        let envConfigPath = Bundle.main.path(forResource: infoPlist!["Info"] as? String, ofType: "plist")
        self.envKeys = NSDictionary(contentsOfFile: envConfigPath!)
    }
    
    /// Used to fetch the Unsplash API key from the Info.plist file.
    ///
    /// If the Unsplash API Key is not present in the Info.plist file, an empty `String` of length `0` would be returned instead of `nil` to avoid the app crashing while handling `nil`.
    /// - Returns: A `String` containing the value of the Unsplash API key.
    func getUnsplashAPIKey() -> String {
        guard let environmentVariables = self.envKeys?.value(forKey: "LSEnvironment") as? [String: String] else {
            return ""
        }
        return environmentVariables["UNSPLASH_API_KEY"] ?? ""
    }
}
