//
//  TeamNameViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/21.
//

import Foundation
import RxSwift
import FirebaseDynamicLinks

class TeamNameViewModel {
    let workspaceCreationRepository = WorkspaceCreationRepository()
    
    let successWorkspaceNamePostSubject = BehaviorSubject<Bool>(value: false)
    let successTeamNamePostSubject = BehaviorSubject<Bool>(value: false)
    let successWorksapceInviteLinkSubject = BehaviorSubject<Bool>(value: false)
    let successWorkspaceProfileSubject = BehaviorSubject<Bool>(value: false)

    
    let disposeBag = DisposeBag()
    
    var workspaceId:Int!
    var workspaceInviteUrlString:String!

    var workspaceCreationData:WorkspaceCreation!
    
    init(workspaceCreationData:WorkspaceCreation) {
        self.workspaceCreationData = workspaceCreationData
    }
    
    func postWorkspaceName() {
        workspaceCreationRepository.postWorkspaceName(name: workspaceCreationData.workspaceName)
            .withUnretained(self)
            .subscribe(onNext: { owner, workspaceCreationResponse in
                if let response = workspaceCreationResponse {
                    owner.workspaceId = response.workspaceId
                    owner.postTeamName()
                    owner.createWorkspaceDynamicLink()
                    owner.postWorkspaceProfile()
                    owner.successWorkspaceNamePostSubject.onNext(true)
                }
            }).disposed(by: disposeBag)
    }
    
    func postWorkspaceProfile() {
        workspaceCreationRepository.postProfile(workspaceProfile: workspaceCreationData.workspaceProfile, workspaceId: String(workspaceId))
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.successWorkspaceProfileSubject.onNext(success)
            }).disposed(by: disposeBag)
    }
    
    func postTeamName() {
        workspaceCreationRepository.postWorkspaceTeamName(name: workspaceCreationData.teamName, workspaceId: workspaceId)
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                owner.successTeamNamePostSubject.onNext(success)
            }).disposed(by: disposeBag)
    }
    
    func saveTeamName(name:String) {
        workspaceCreationData.teamName = name
    }
    
    func createWorkspaceDynamicLink() {
        let link = URL(string: "https://ronmee.page.link?id=\(workspaceId!)")!
        let domainURIPrefix = "https://ronmee.page.link"
        let referralLink = DynamicLinkComponents(link: link, domainURIPrefix: domainURIPrefix)
        
        referralLink?.iOSParameters = DynamicLinkIOSParameters(bundleID: "com.fourtune.Meeron")
        referralLink?.iOSParameters?.minimumAppVersion = "1.0.1"
        referralLink?.iOSParameters?.appStoreID = "0"
        
        referralLink?.androidParameters = DynamicLinkAndroidParameters(packageName: "fourtune.meeron")
        
        
        referralLink?.shorten(completion: {  shortURL, warnings, error in
            guard let url = shortURL else {return}
            print("✔️:", url)
            self.workspaceInviteUrlString = "\(url)"
            self.successWorksapceInviteLinkSubject.onNext(true)
        })
    }
    
}
