//
//  Date.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/16.
//
import Foundation

extension Date {

    /**
     # formatted
     - Parameters:
        - format: 변형할 DateFormat
     - Note: DateFormat으로 변형한 String 반환
    */
    
    public func formatted(_ format: String) -> String {
        let formatter = DateFormatter()
        print("my format: \(format)")
        formatter.dateFormat = format
        formatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)!
        
        return formatter.string(from: self)
    }
}

//나중에 사용할 때 Date().formatted("yyyy-MM-dd")
