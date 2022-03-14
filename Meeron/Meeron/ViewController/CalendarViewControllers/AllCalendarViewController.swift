//
//  AllCalendarViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/02/26.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AllCalendarViewController:UIViewController {
    
    @IBOutlet weak var yearTableView:UITableView!
    
    @IBOutlet weak var monthCollectionView: UICollectionView!
    
    
    var nowDate = PublishSubject<String>()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        bind()
    }
    
    private func bind(){
        monthCollectionView.rx.itemSelected.subscribe(onNext: {
            self.nowDate.onNext(String($0.last!+1))
        }).disposed(by: disposeBag)
    }
    
    func configureCollectionView(){
        monthCollectionView.dataSource = self
        monthCollectionView.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        //layout.itemSize = CGSize(width:UIScreen.main.bounds.width/3, height: monthCollectionView.bounds.height/6)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        
        monthCollectionView.collectionViewLayout = layout
    }
    
    
    @IBAction func closeView(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    
}

extension AllCalendarViewController:UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MonthCell", for: indexPath)
        return cell
    }
    
}

extension AllCalendarViewController:UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:UIScreen.main.bounds.width/3, height: monthCollectionView.bounds.height/6)
    }
}

