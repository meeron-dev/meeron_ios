//
//  AppDelegate.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/19.
//

import UIKit
import RxKakaoSDKAuth
import KakaoSDKAuth
import KakaoSDKCommon
import AuthenticationServices
import Firebase
import AWSS3

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
            if (AuthApi.isKakaoTalkLoginUrl(url)) {
                return AuthController.rx.handleOpenUrl(url: url)
            }

            return false
        }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        KakaoSDK.initSDK(appKey: Bundle.main.kakaoAppKey)
        
        FirebaseApp.configure()
        
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APNortheast2,
                                                                identityPoolId: Bundle.main.s3PoolId)
        let configuration = AWSServiceConfiguration(region:.APNortheast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        
        /*self.window = UIWindow(frame: UIScreen.main.bounds)
        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
        let initialViewController = mainStroyboard.instantiateViewController(withIdentifier: "LoginViewController")
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()*/
        
        /*
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            appleIDProvider.getCredentialState(forUserID: "001977.ccb7e61f3d4848728ad4a65391e05f44.1405") { credentialState, error in
                switch credentialState {
                case .authorized:
                    print("인증 성공")
                    DispatchQueue.main.async {
                        let mainStroyboard = UIStoryboard(name: "Main", bundle: nil)
                        let initialViewController = mainStroyboard.instantiateViewController(withIdentifier: "TabBarController")
                        self.window = UIWindow(frame: UIScreen.main.bounds)
                        self.window?.rootViewController = initialViewController
                        self.window?.makeKeyAndVisible()
                    }
                case .revoked:
                    print("인증 만료")
                default:
                    print("예외 상황")
                }
            }
        }*/
        
    
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

