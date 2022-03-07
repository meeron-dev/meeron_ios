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
    
    var
    var selectedProfileUserIds:[Int] = []
    var userProfilesSubject = PublishSubject<[WorkspaceUser]>()
    
    
    
    let disposeBag = DisposeBag()
    
    
    
    func addSelectedProfileUserIds(id:Int) {
        if !selectedProfileUserIds.contains(id) {
            selectedProfileUserIds.append(id)
        }
    }
    
    func deleteSelectedProfileUserIds(id:Int) {
        if let index = selectedProfileUserIds.firstIndex(of: id) {
            selectedProfileUserIds.remove(at: index)
        }
    }
    
    
    func loadUserInWorkspace(searchNickname:String) {
        let urlString = URLConstant.workspaceUserProfile+"?workspaceId=1&nickname="+searchNickname
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
