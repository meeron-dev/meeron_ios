//
//  SceneDelegate.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                _ = AuthController.rx.handleOpenUrl(url: url)
            }
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        window?.tintColor = UIColor.mrBlue
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        /*
        self.window = UIWindow(windowScene: windowScene)
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStroyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()*/
        
        guard let _ = (scene as? UIWindowScene) else {return}
        if let url = connectionOptions.urlContexts.first?.url {
            schemeHandlerURL(url: url)
        }
    }
    
    func schemeHandlerURL(url: URL) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let rootVC = storyboard.instantiateViewController(withIdentifier: "IntroductionViewController") as? IntroductionViewController else {return}
        self.window?.rootViewController = rootVC
        self.window?.makeKeyAndVisible()
        
        let urlStr = url.absoluteString //스키마 주소값
        let components = URLComponents(string: urlStr)
        let schemeData = components?.scheme ?? "" //스키마
        let parameter = components?.query ?? "" //파라미터
        
        print("urlStr : ", urlStr)
        print("scheme : ", schemeData)
        print("query : ", parameter)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

