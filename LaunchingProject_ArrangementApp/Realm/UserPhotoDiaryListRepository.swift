//
//  UserPhotoDiaryListRepository.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/17.
//

import Foundation
import RealmSwift

class UserPhotoDiaryListRepository {
    
    var mainView = UserPhotoDiary()
    
    var localRealm = try! Realm() // Realm2. Realm 테이블 경로 가져오기. 이 통로를 통해서 데이터를 가져올거야~
    
    //MARK: - 이미지 정렬
//    func fetch() -> Results<UserPhotoDiary> {
//        //3. Realm 데이터를 정렬해 tasks에 담기
//        return localRealm.objects(UserPhotoDiary.self).sorted(byKeyPath: "regDate", ascending: true)
//    }
    
    //MARK: - 이미지, 데이터 추가
    func addItem(data: UserPhotoDiary) {
//        let data = UserThingDiary(imageCount: imageCount, content: content, regDate: Date())

        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 중복 제거된 열 (테이블 섹션 이름)
    func fetchSectionHeader() -> [String] {
        let placeSectionList = localRealm.objects(UserPhotoDiary.self)
        let uniqueSectionList = placeSectionList.distinct(by: ["place"]).sorted(byKeyPath: "regDate", ascending: true)
        var list: [String] = []
        if uniqueSectionList.count > 0 {
            for i in 0...uniqueSectionList.count - 1 {
                list.append(uniqueSectionList[i].place)
            }
        }
        return list
    }
    
    //MARK: - 섹션 별 컬렉션뷰셀 (이미지, 날짜 가져오기)
    func fetchFilterbyPlace(place: String) -> Results<UserPhotoDiary> {
        return self.localRealm.objects(UserPhotoDiary.self).filter("place = '\(place)'").sorted(byKeyPath: "regDate", ascending: false)
    }
    
    //MARK: - 삭제
    func delete(data: UserPhotoDiary) {
        do {
            try self.localRealm.write {
                self.localRealm.delete(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    func resetLocalRealm() {
        let username = UserDefaults.standard.string(forKey: "filename") ?? "default"
        
        var config = Realm.Configuration.defaultConfiguration
        config.fileURL!.deleteLastPathComponent()
        config.fileURL!.appendPathComponent(username)
        config.fileURL!.appendPathExtension("realm")
        config.schemaVersion = 2
        
        localRealm = try! Realm(configuration: config)
    }
}
