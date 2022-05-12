//
//  SceneDelegate.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene:  scene)
        
        var storyboard: UIStoryboard!
        var controller: UIViewController!
        
        if UserDefaults.standard.hasOnboarded {
            storyboard = UIStoryboard(name: "TabView", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: TabViewController.identifier) as! TabViewController
           
        } else {
            storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            controller = storyboard.instantiateViewController(withIdentifier: OnboardingViewController.identifier) as! OnboardingViewController
        }
        
        window?.rootViewController = controller
        window?.makeKeyAndVisible()
    }
}

