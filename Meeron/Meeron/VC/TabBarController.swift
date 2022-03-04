//
//  TabBarController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/22.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa


class TabBarController:UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTabBarUI()
        
    }
    private func setupTabBarUI() {
        self.tabBar.backgroundColor = UIColor.tabBarBackGroundGray
        let newTabBarHeight = self.tabBar.frame.size.height + 9
        self.tabBar.frame.size.height = newTabBarHeight
        
        self.tabBar.frame.origin.y = view.frame.size.height - newTabBarHeight
        self.tabBar.layer.cornerRadius = 15
        
    }
}
