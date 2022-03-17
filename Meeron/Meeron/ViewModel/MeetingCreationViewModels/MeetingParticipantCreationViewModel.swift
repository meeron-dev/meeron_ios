//
//  MeetingParticipantCreationViewModel.swift
//  Meeron
//
//  Created by 심주미 on 2022/03/06.
//

import Foundation
import RxSwift

class MeetingParticipantCreationViewModel {
    var teams:[Team] = []
    let teamsSubject = BehaviorSubject<[Team]>(value: [])
    
    var nowTeam:Team?
    let nowTeamSubject = BehaviorSubject<Team?>(value: nil)
    
    var userProfiles:[WorkspaceUser] = []
    let userProfilesSubejct = PublishSubject<[WorkspaceUser]>()
    
    var selectedUserProfiles:[WorkspaceUser] = []
    var selectedUserProfilesSubject = PublishSubject<[WorkspaceUser]>()
    var selectedUserProfilesCountSubject = BehaviorSubject<Int>(value: 0)
    
    var meetingCreationData:MeetingCreation?
    let meetingDateSubject = BehaviorSubject<String>(value: "")
    let meetingTimeSubject = BehaviorSubject<String>(value: "")
    let meetingTitleSubject = BehaviorSubject<String>(value: "")
    
    let teamRepository = TeamRepository()
    let meetingCreationRepository = MeetingCreationRepository()
    
    let sucessMeetingDocumentCreationSubject = PublishSubject<Bool>()
    var sucessMeetingDocumentsCreationCount = 0
    let sucessMeetingDocumentsCreationSubject = BehaviorSubject<Bool>(value: false)
    let sucessMeetingParticipantCreationSubject = BehaviorSubject<Bool>(value: false)
    
    let disposeBag = DisposeBag()
    
    init(){
        nowTeamSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, team in
                owner.chageNowTeam(team: team)
            }).disposed(by: disposeBag)
        
        selectedUserProfilesSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                owner.meetingCreationData?.participants = users
            }).disposed(by: disposeBag)
        
    }
    
    func isManager(data:WorkspaceUser) -> Bool {
        guard let meetingCreationData = meetingCreationData else {
            return false
        }

        if meetingCreationData.managers.contains(data) ||
            UserDefaults.standard.string(forKey: "workspaceNickname") == data.nickname {
            return true
        }else {
            return false
        }
    }
    
    func chageNowTeam(team:Team?) {
        if let nowTeam = nowTeam {
            teams.append(nowTeam)
        }
        if let team = team {
            if let index = teams.firstIndex(of:team) {
                teams.remove(at: index)
            }
        }
        teamsSubject.onNext(teams)
        nowTeam = team
        loadUsersInWorkspaceTeam()
    }
    
    func isSelectedUserProfile(data:WorkspaceUser) -> Bool {
        if selectedUserProfiles.contains(data) {
            return true
        }
        return false
    }
    
    func addSelectedUserProfile(data:WorkspaceUser) {
        selectedUserProfiles.append(data)
        selectedUserProfilesSubject.onNext(selectedUserProfiles)
        selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count + meetingCreationData!.managers.count+1)
    }
    
    func updateSelectedUserProfiles(data:[WorkspaceUser]) {
        selectedUserProfiles = data
        selectedUserProfilesSubject.onNext(selectedUserProfiles)
        selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count + meetingCreationData!.managers.count+1)
        userProfilesSubejct.onNext(userProfiles)
    }
    
    func deleteSelectedUserProfile(data:WorkspaceUser) {
        if let index = selectedUserProfiles.firstIndex(of: data) {
            selectedUserProfiles.remove(at: index)
            selectedUserProfilesSubject.onNext(selectedUserProfiles)
            selectedUserProfilesCountSubject.onNext(selectedUserProfiles.count + meetingCreationData!.managers.count+1)
        }
    }
    
    func selectUserProfile(data:WorkspaceUser) {
        if isSelectedUserProfile(data: data) {
            deleteSelectedUserProfile(data: data)
        }else {
            addSelectedUserProfile(data: data)
        }
        userProfilesSubejct.onNext(userProfiles)
    }
    
    func loadTeamInWorkspace() {
        teamRepository.loadTeamInWorkspace()
            .withUnretained(self)
            .subscribe(onNext: { owner, teams in
                if let teams = teams {
                    if teams.teams.count > 0 {
                        owner.nowTeamSubject.onNext(teams.teams[0])
                    }
                    if teams.teams.count > 1 {
                        owner.teams = Array(teams.teams[1...])
                        owner.teamsSubject.onNext(Array(teams.teams[1...]))
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func loadUsersInWorkspaceTeam() {
        guard let nowTeam = nowTeam else {
            return
        }
        
        teamRepository.loadUsersInWorkspaceTeam(teamId: String(nowTeam.teamId))
            .withUnretained(self)
            .subscribe(onNext: { owner, users in
                if let users = users {
                    owner.userProfiles = users.workspaceUsers
                    owner.userProfilesSubejct.onNext(users.workspaceUsers)
                }
                
            }).disposed(by: disposeBag)
    }
    
    func setMeetingCreationData(data: MeetingCreation) {
        meetingCreationData = data
        meetingDateSubject.onNext(data.date.toKoreanDateString())
        meetingTimeSubject.onNext(data.startTime.toATimeString() + " ~ " + data.endTime.toATimeString())
        meetingTitleSubject.onNext(data.title)
        selectedUserProfilesCountSubject.onNext(meetingCreationData!.managers.count+1)  //1은 회의 생성자
        loadTeamInWorkspace()
    }
    
    
    func createMeeting() {
        createMeetingBasicInfo()
    }
    
    func createMeetingBasicInfo() {
        meetingCreationRepository.createMeeting(data: meetingCreationData!)
            .withUnretained(self)
            .subscribe(onNext: { owner, meeting in
                if let meeting = meeting {
                    owner.meetingCreationData?.meetingId = String(meeting.meetingId)
                    owner.createMeetingParticipant()
                    owner.createMeetingAgenda()
                    print("미팅 id", meeting.meetingId)
                }else {
                    print("미팅 생성 실패")
                }
            }).disposed(by: disposeBag)
    }
    
    func createMeetingParticipant() {
        if meetingCreationData!.participants.count == 0 {
            sucessMeetingParticipantCreationSubject.onNext(true)
        }else {
            meetingCreationRepository.createMeetingParticipant(data: meetingCreationData!, meetingId: meetingCreationData!.meetingId)
                .withUnretained(self)
                .subscribe(onNext: { owner, success in
                    print("참가자 생성", success)
                    owner.sucessMeetingParticipantCreationSubject.onNext(success)
                }).disposed(by: disposeBag)
        }
    }
    
    func createMeetingAgenda() {
        if meetingCreationData!.agendas.count == 0 {
            sucessMeetingDocumentsCreationSubject.onNext(true)
            return
        }else if meetingCreationData!.agendas.count == 1 {
            if meetingCreationData!.agendas[0] == Agenda() {
                sucessMeetingDocumentsCreationSubject.onNext(true)
                return
            }
        }
        
        meetingCreationRepository.createMeetingAgenda(datas: meetingCreationData!.agendas, meetingId: meetingCreationData!.meetingId)
            .withUnretained(self)
            .subscribe(onNext: { owner, response in
                if let response = response {
                    print("아젠다 생성 성공")
                    owner.createMeetingDocuments(agendaId: response.createdAgendaIds)
                }
                
            }).disposed(by: disposeBag)
        
    }
    
    func createMeetingDocuments(agendaId:[Int]) {
        var totalDocumentCount = 0
        for i in 0..<meetingCreationData!.agendas.count {
            totalDocumentCount += meetingCreationData!.agendas[i].document.count
        }
        if totalDocumentCount == 0 {
            sucessMeetingDocumentsCreationSubject.onNext(true)
            return
        }
        
        sucessMeetingDocumentCreationSubject
            .withUnretained(self)
            .subscribe(onNext: { owner, sucess in
                if sucess {
                    owner.sucessMeetingDocumentsCreationCount += 1
                    if owner.sucessMeetingDocumentsCreationCount == totalDocumentCount {
                        owner.sucessMeetingDocumentsCreationSubject.onNext(true)
                    }
                }
            }).disposed(by: disposeBag)
        
        for i in 0..<agendaId.count {
            let id = agendaId[i]
            for j in 0..<meetingCreationData!.agendas[i].document.count {
                createMeetingDocument(data: meetingCreationData!.agendas[i].document[j].data, agendaId: id)
            }
        }
    }
    
    func createMeetingDocument(data:Data, agendaId:Int) {
        meetingCreationRepository.createMeetingDocument(data:data, agendaId: String(agendaId))
            .withUnretained(self)
            .subscribe(onNext: { owner, success in
                print("문서생성",success)
                owner.sucessMeetingDocumentCreationSubject.onNext(success)
            }).disposed(by: disposeBag)
    }
}
