//
//  ManagerSelectViewController.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/03.
//

import Foundation
import UIKit
import RxSwift

protocol MeetingProfileSelectViewControllerDelegate: AnyObject {
    func passSelectedProfiles(selectedProfiles:[WorkspaceUser])
}

class MeetingProfileSelectViewController:UIViewController {
    @IBOutlet weak var profileCollectionView: UICollectionView!
    
    @IBOutlet weak var profileSelectTitleLabel: UILabel!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    let meetingProfileSelectVM = MeetingProfileSelectViewModel()
    
    var delegate:MeetingProfileSelectViewControllerDelegate?
    
    var viewTranslation = CGPoint(x: 0, y: 0)
    var viewVelocity = CGPoint(x: 0, y: 0)
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setupCollectionView()
        addGestureRecognizer()
    }
    
    func addGestureRecognizer() {
        let tapper = UITapGestureRecognizer(target: self, action:#selector(dismissKeyboard))
        view.addGestureRecognizer(tapper)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(dismissWithPanGesture))
        view.addGestureRecognizer(panGesture)
    }
    
    @objc func dismissWithPanGesture(_ sender:UIPanGestureRecognizer) {
        viewTranslation = sender.translation(in: view)
        viewVelocity = sender.velocity(in: view)
        
        switch sender.state {
        case .changed:
            if abs(viewVelocity.y) > abs(viewVelocity.x) {
                if viewVelocity.y > 0 {
                    UIView.animate(withDuration: 0.1) {
                        self.view.transform = CGAffineTransform(translationX: 0, y: self.viewTranslation.y)
                    }
                }
            }
        case .ended:
            if viewTranslation.y < 400 {
                UIView.animate(withDuration: 0.1) {
                    self.view.transform = .identity
                }
            } else {
                dismiss(animated: true, completion: nil)
            }
        default:
            break
        }

    }
    
    private func configureUI() {
        doneButton.addShadow()
        
        meetingProfileSelectVM.selectedUserProfilesSubject
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: {
                if $0.count > 0 {
                    self.doneButton.isEnabled = true
                }else {
                    self.doneButton.isEnabled = false
                }
            }).disposed(by: disposeBag)
        
        setupTextField()
        
    }
    
    private func setupTextField() {
        searchTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: {
                self.meetingProfileSelectVM.loadUserInWorkspace(searchNickname: $0)
            }).disposed(by: disposeBag)
    }
    
    private func setupCollectionView() {
        profileCollectionView.register(UINib(nibName: "MeetingProfileSelectCell", bundle: nil), forCellWithReuseIdentifier: "MeetingProfileSelectCell")
        
        meetingProfileSelectVM.userProfilesSubject.bind(to: profileCollectionView.rx.items) { collectionView, row, element in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MeetingProfileSelectCell", for: IndexPath(row: row, section: 0)) as! MeetingProfileSelectCell
            cell.setData(data: element, vm: self.meetingProfileSelectVM)
            return cell
        }.disposed(by: disposeBag)
        
        profileCollectionView.rx.itemSelected.subscribe(onNext: {
            print($0)
        }).disposed(by: disposeBag)
        
        setupCollectionViewLayout()
        
    }
    
    private func setupCollectionViewLayout() {
        let profileCollectionViewLayout = UICollectionViewFlowLayout()
        profileCollectionViewLayout.itemSize = CGSize(width: 70, height: 100)
        profileCollectionViewLayout.minimumInteritemSpacing = 10
        profileCollectionViewLayout.minimumLineSpacing = 20
        
        profileCollectionView.collectionViewLayout = profileCollectionViewLayout
    }


    @IBAction func done(_ sender: Any) {
        delegate?.passSelectedProfiles(selectedProfiles: meetingProfileSelectVM.selectedUserProfiles)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

