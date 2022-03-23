//
//  SceneDelegate.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import FirebaseDynamicLinks
import RxSwift


class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    let disposeBag = DisposeBag()
    
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
        
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        window?.tintColor = .mrBlue
        
        setInitialView(type: getUserSignUpState())

    }
    
    func getUserSignUpState() -> UserSignUpState {
        if hasToken() {
            if let _ = UserDefaults.standard.string(forKey: "userName") {
                return .home
            }else {
                if UserDefaults.standard.bool(forKey: "termsAgree") {
                    return .userName
                }
                else {
                    return .terms
                }
            }
        }else {
            return .login
        }
        
    }
    
    func setInitialView(type:UserSignUpState) {
        
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch type {
        case .login:
            let loginVC = mainStroyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            self.window?.rootViewController = loginVC
        case .terms:
            let termsVC = mainStroyboard.instantiateViewController(withIdentifier: "TermsViewController") as! TermsViewController
            self.window?.rootViewController = termsVC
        case .userName:
            let userNameVC = mainStroyboard.instantiateViewController(withIdentifier: "UserNameViewController") as! UserNameViewController
            self.window?.rootViewController = userNameVC
        case .home:
            let homeVC = mainStroyboard.instantiateViewController(withIdentifier:"TabBarController") as! TabBarController
            self.window?.rootViewController = homeVC
        }
        
        self.window?.makeKeyAndVisible()
    }
    
    func hasToken() -> Bool {
        if let _ = KeychainManager().read(service: "Meeron", account: "accessToken") {
            return true
        }
        return false
    }
   
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        
        if let incomingURL = userActivity.webpageURL {
            let _ = DynamicLinks.dynamicLinks().handleUniversalLink(incomingURL) { [weak self] dynamicLinks, error in
                if let dynamicLinks = dynamicLinks {
                    print("🥳",dynamicLinks.url)
                    if let id = dynamicLinks.url?.query?.split(separator: "=")[1] {
                        self?.setInitialViewByWorkspaceParticipant(workspaceId: String(id))
                    }
                }
            }
          
        }
    }
    
    func setInitialViewByWorkspaceParticipant(workspaceId:String) {
        let userSignUpState = getUserSignUpState()
        
        if userSignUpState == .terms || userSignUpState == .userName || userSignUpState == .login {
            let userErrorVC = UserErrorViewController(nibName: "UserErrorViewController", bundle: nil)
            userErrorVC.userSignUpState = userSignUpState
            self.window?.rootViewController = userErrorVC
        }else {
            let workspaceParicipationProfileCreationVC = WorkspaceParicipationProfileCreationViewController(nibName: "WorkspaceParicipationProfileCreationViewController", bundle: nil)
            workspaceParicipationProfileCreationVC.workspaceId = workspaceId
            self.window?.rootViewController = workspaceParicipationProfileCreationVC
        }
        
        self.window?.makeKeyAndVisible()
        
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

