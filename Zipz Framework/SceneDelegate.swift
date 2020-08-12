//
//  SceneDelegate.swift
//  Zipz Framework
//
//  Created by Mirko Trkulja on 05/04/2020.
//  Copyright © 2020 Aware. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        ZipzDatabase.saveContext()
    }
}

