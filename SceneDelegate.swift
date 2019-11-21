//
//  SceneDelegate.swift
//  You Decide
//
//  Created by Abdullah Bandan on 01/03/1441 AH.
//  Copyright © 1441 AbdullahBandan. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func sceneDidEnterBackground(_ scene: UIScene) {
        (UIApplication.shared.delegate as? AppDelegate)?.viewContext()
    }


}

