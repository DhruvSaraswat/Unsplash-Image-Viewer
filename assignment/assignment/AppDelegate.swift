//
//  AppDelegate.swift
//  assignment
//
//  Created by Saraswat, Dhruv on 04/04/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        window?.backgroundColor = .white
        window?.rootViewController = ImageListScreenRouter.createModule()
        window?.makeKeyAndVisible()
        
        return true
    }
    
}

