//
//  FileManager + Extension.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/14.
//

import UIKit

extension UIViewController {
    
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } //Document 경로
        return documentDirectory
    }
    
    //MARK: - The1stVC - ThingDiary 이미지 - 도큐먼트 저장 코드
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //용량 줄이기
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
  
    
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치)
        //fileURL이 있는지 물어보는 코드
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) // 이 위치에 있는걸 이미지로 담기
        } else {
            return UIImage(named: "camera")
        }
    }
    
    //사용자에게 zip파일 목록을 보여주는 코드(테이블뷰로 나타내볼 수 있다)
    //result: ["SeSACDiary_1.zip"] (여기 아래 코드에서 디버그창에 이거 뜨는데 이걸 사용자에게 테이블뷰로 띄워서 보여주면 됨)
    func fetchDocumentZipFile() {
        
        do {
            guard let path = documentDirectoryPath() else { return }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("docs: \(docs)")
            
            //pathExtension: 확장자를 의미함
            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent }
            print("result: \(result)")
            
        } catch {
            print("Error")
        }
    }
    
    func checkFileExists(fileName: String) -> Bool {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return false } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치
        //fileURL이 있는지 물어보는 코드
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
}
