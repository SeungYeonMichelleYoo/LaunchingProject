//
//  PhotoDiary.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/17.
//
import Foundation
import RealmSwift

class UserPhotoDiary: Object {
    @Persisted var place: String //장소(필수)
    @Persisted var imageCount: Int //이미지(필수)
    @Persisted var regDate = Date() //등록날짜(필수)
    
    //PrimaryKey= PK(필수): Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId //Object가 초기화될 때마다 1씩 증가
    
    convenience init(place: String, imageCount: Int, regDate: Date) {
        self.init()
        self.place = place
        self.imageCount = imageCount
        self.regDate = regDate
    }
}

//database에 행이 추가될 때 objectId 자동 생성되는 걸 이용해서 이미지 이름을 {objectId}.jpg 로 저장
