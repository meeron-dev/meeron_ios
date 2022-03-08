//
//  MeetingProfileSelectViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/07.
//

import Foundation
import RxSwift
import Alamofire

class MeetingProfileSelectViewModel {
    
    var selectedUserProfilesSubject = BehaviorSubject<[WorkspaceUser]>(value: [])
    var selectedUserProfiles:[WorkspaceUser] = []
    var userProfilesSubject = PublishSubject<[WorkspaceUser]>()
    
    
    
    let disposeBag = DisposeBag()
    
    
    
    func addSelectedProfileUserIds(profile:WorkspaceUser) {
        if !selectedUserProfiles.contains(profile) {
            selectedUserProfiles.append(profile)
            selectedUserProfilesSubject.onNext(selectedUserProfiles)
        }
    }
    
    func deleteSelectedProfileUserIds(profile:WorkspaceUser) {
        if let index = selectedUserProfiles.firstIndex(of: profile) {
            selectedUserProfiles.remove(at: index)
            selectedUserProfilesSubject.onNext(selectedUserProfiles)
        }
    }
    
    func isSelectedProfile(profile:WorkspaceUser) -> Bool {
        if selectedUserProfiles.contains(profile) {
            return true
        }
        return false
    }
    
    
    func loadUserInWorkspace(searchNickname:String) {
        guard let workspaceId = UserDefaults.standard.string(forKey: "workspaceId") else {return}
        
        let urlString = URLConstant.workspaceUserProfile+"?workspaceId="+workspaceId+"&nickname="+searchNickname
        let encodedURLString = urlString.addingPercentEncoding(withAllowedCharacters:.urlQueryAllowed)
        
        guard let encodedURLString = encodedURLString else {
            return
        }

        let resource = Resource<WorkspaceUserProfiles>(url:encodedURLString, parameter: [:], headers: [.authorization(bearerToken: KeychainManager().read(service: "Meeron", account: "accessToken")!)], method: .get, encodingType: .URLEncoding)
        
        API().load(resource: resource)
            .subscribe(onNext: { workspaceUserProfiles in
                if let workspaceUserProfiles = workspaceUserProfiles {
                    self.userProfilesSubject.onNext(workspaceUserProfiles.workspaceUsers)
                }
            }).disposed(by: disposeBag)
    }
    
}
