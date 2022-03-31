//
//  AgendaViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/31.
//

import Foundation
import UIKit

class AgendaViewController:UIViewController {
    
    @IBOutlet weak var agendaNumberCollectionView:UICollectionView!
    
    @IBOutlet weak var agendaCheckButton:UIButton!
    @IBOutlet weak var agendaTitleLabel:UILabel!
    
    @IBOutlet weak var issueTableView:UITableView!
    @IBOutlet weak var documentTableView:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        setupCollectionView()
    }
    
    func configureUI() {
        if #available(iOS 13, *) {
            view.addSubview(UIView.statusBar)
        }
        
        
    }
    
    func setupCollectionView() {
        agendaNumberCollectionView.register(UINib(nibName: "MeetingNumberCell", bundle: nil), forCellWithReuseIdentifier: "MeetingNumberCell")
    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
