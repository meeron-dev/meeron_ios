//
//  TabBarController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/22.
//

import Foundation
import UIKit


class TabBarController:UITabBarController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() { //왜 여기서 호출해야지 되는거임..????
        super.viewDidLayoutSubviews()
        setupTabBarUI()
    }
    private func setupTabBarUI() {
        self.tabBar.backgroundColor = UIColor.tabBarBackGroundGray
        self.tabBar.frame.size.height = 91
        self.tabBar.frame.origin.y = view.frame.size.height - 91
        self.tabBar.layer.cornerRadius = 15
        
    }
}
