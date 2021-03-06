//
//  UICollectionViewFlowLayout+CustomLayout.swift
//  Meeron
//
//  Created by 심주미 on 2022/04/02.
//

import Foundation
import UIKit


extension UICollectionViewFlowLayout {
    
    static var profileCollectionViewLayout:UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 70, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        return layout
    }
    
    static var numberCollectionViewlayout: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 44, height: 44)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 0, left: 13, bottom: 0, right: 13)
        return layout
    }
}
