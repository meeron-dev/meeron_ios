//
//  FileManagerViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/11.
//

import Foundation
import UIKit

class FileManagerViewController: UIViewController, FileManagerDelegate {
    let fileManager = FileManager.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsURL.appendingPathComponent("ㅇㅇㅇ의 파일.txt")
        
    }
}
