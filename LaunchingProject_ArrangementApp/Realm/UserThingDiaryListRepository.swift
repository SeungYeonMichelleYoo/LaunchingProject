//
//  UserThingDiaryListRepository.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/14.
//

import Foundation
import RealmSwift

class UserThingDiaryListRepository {
    
    var mainView = ThingDiaryView()
    
    var localRealm = try! Realm()
                                
    //MARK: - 이미지 정렬
    func fetch() -> Results<UserThingDiary> {
        //3. Realm 데이터를 정렬해 tasks에 담기
        return localRealm.objects(UserThingDiary.self).sorted(byKeyPath: "regDate", ascending: false)
    }
    
    //MARK: - 이미지 & 내용 추가
    func addItem(data: UserThingDiary) {
//        let data = UserThingDiary(imageCount: imageCount, content: content, regDate: Date())

        do {
            try localRealm.write {
                localRealm.add(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 삭제
    func delete(data: UserThingDiary) {
        do {
            try self.localRealm.write {
                self.localRealm.delete(data)
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 수정
    func modify(data: UserThingDiary, content: String) {
        
        guard let modifiedData = localRealm.object(ofType: UserThingDiary.self, forPrimaryKey: data.objectId) else {
            print("UserThing not found")
            return
        }
        
        do {
            try self.localRealm.write {
                modifiedData.content = content
            }
        } catch let error {
            print(error)
        }
    }
    
    //MARK: - 섹션 별 컬렉션뷰셀 (이미지, 날짜 가져오기)
    func fetchFilterbyPlace(place: String) -> Results<UserThingDiary> {
        return self.localRealm.objects(UserThingDiary.self).filter("place = '\(place)'").sorted(byKeyPath: "regDate", ascending: false)
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
