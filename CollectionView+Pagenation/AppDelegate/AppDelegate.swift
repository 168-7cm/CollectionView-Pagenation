//
//  AppDelegate.swift
//  CollectionView+Pagenation
//
//  Created by kou yamamoto on 2021/12/08.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        window.rootViewController = StoryboardScene.Main.main.instantiate()
        self.window = window
        window.makeKeyAndVisible()
        return true
    }
}

