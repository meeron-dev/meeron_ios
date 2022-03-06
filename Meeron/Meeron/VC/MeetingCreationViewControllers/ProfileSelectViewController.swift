//
//  ManagerSelectViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit

class ProfileSelectViewController:UIViewController {
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var profileSelectTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
        
        
    }
    
    private func configureUI() {
        closeButton.addShadow()
        doneButton.addShadow()
        
        setupCollectionView()
        setupCollectionViewLayout()
        
    }
    
    private func setupCollectionView() {
        profileCollectionView.dataSource = self
        profileCollectionView.delegate = self
        profileCollectionView.register(UINib(nibName: "MeetingParticipantProfileCell", bundle: nil), forCellWithReuseIdentifier: "MeetingParticipantProfileCell")
    }
    
    private func setupCollectionViewLayout() {
        let profileCollectionViewLayout = UICollectionViewFlowLayout()
        profileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        profileCollectionViewLayout.minimumInteritemSpacing = 10
        profileCollectionViewLayout.minimumLineSpacing = 20
        
        profileCollectionView.collectionViewLayout = profileCollectionViewLayout
    }
    
    @IBAction func close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func done(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension ProfileSelectViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingParticipantProfileCell", for: indexPath)
        return cell
    }
    
    
}
