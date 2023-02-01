//
//  BackupViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/10.
//

import UIKit
import SnapKit
import Zip
import RealmSwift

class BackupViewController: BaseViewController {
    
    var mainView = BackupView()
    
    let localRealm = try! Realm()
    var photoTasks: Results<UserPhotoDiary>!
    var thingTasks: Results<UserThingDiary>!
    

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photoTasks = localRealm.objects(UserPhotoDiary.self)
        thingTasks = localRealm.objects(UserThingDiary.self)
                
        self.navigationItem.title = "백업 및 복구"
        
        fetchDocumentZipFile()
        
        mainView.backupButton.addTarget(self, action: #selector(backupBtnClicked), for: .touchUpInside)
        mainView.restoreButton.addTarget(self, action: #selector(restoreBtnClicked), for: .touchUpInside)
        
        setNavBackBtn()
    }
    
    @objc func backupBtnClicked() {
        
        var urlPaths = [URL]()
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.", button: "확인")
            return
        }
        
        let realmFile = path.appendingPathComponent("default.realm")
        
        guard FileManager.default.fileExists(atPath: realmFile.path) else {
            showAlertMessage(title: "백업할 파일이 없습니다.", button: "확인")
            return
        }
        
        let newName = String(Int(Date().timeIntervalSince1970))
        let newFile = path.appendingPathComponent("\(newName).realm")
        do {
            try FileManager.default.copyItem(at: URL(fileURLWithPath: realmFile.path), to: URL(fileURLWithPath: newFile.path))
        } catch (let error) {
            print(error)
        }
        
        let textPath: URL = path.appendingPathComponent("name.txt")
        if let data: Data = newName.data(using: String.Encoding.utf8) { // String to Data
            do {
                try data.write(to: textPath) // 위 data를 "hi.txt"에 쓰기
            } catch let e {
                print(e.localizedDescription)
            }
        }        //압축 대상을 urlPaths에 append
        urlPaths.append(URL(string: newFile.path)!)
        urlPaths.append(URL(string: textPath.path)!)
        
        //MARK: - img 추가
        if photoTasks.count > 0 {
            for i in 0...(photoTasks.count-1) {
                let filename = "\(photoTasks[i].objectId)_1.jpg"
                if checkFileExists(fileName: filename) {
                    let filePath = path.appendingPathComponent(filename)
                    urlPaths.append(URL(string: filePath.path)!)
                }
            }
        }
        
        if thingTasks.count > 0 {
            for i in 0...(thingTasks.count-1) {
                let filename = "\(thingTasks[i].objectId)_1.jpg"
                if checkFileExists(fileName: filename) {
                    let filePath = path.appendingPathComponent(filename)
                    urlPaths.append(URL(string: filePath.path)!)
                }
            }
        }
        

        //백업 파일을 압축: URL
        do {
            let zipFilePath = try Zip.quickZipFiles(urlPaths, fileName: "BackupFile")
            print("Archive Location: \(zipFilePath)")
            showActivityViewController()
        } catch {
            showAlertMessage(title: "압축을 실패했습니다.", button: "확인")
        }
    }

    
    func showActivityViewController() {
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
        
        let backupFileURL = path.appendingPathComponent("BackupFile.zip")
        
        let vc = UIActivityViewController(activityItems: [backupFileURL], applicationActivities: [])
        self.present(vc, animated: true)
    }
    
    @objc func restoreBtnClicked() {
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: [.archive], asCopy: true)
        documentPicker.delegate = self
        documentPicker.allowsMultipleSelection = false
        self.present(documentPicker, animated: true)
    }
}

extension BackupViewController: UIDocumentPickerDelegate {
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print(#function)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let selectedFileURL = urls.first else {
            showAlertMessage(title: "선택하신 파일을 찾을 수 없습니다.")
            return
        }
        
        guard let path = documentDirectoryPath() else {
            showAlertMessage(title: "도큐먼트 위치에 오류가 있습니다.")
            return
        }
  
        let sandboxFileURL = path.appendingPathComponent(selectedFileURL.lastPathComponent)
        
        if FileManager.default.fileExists(atPath: sandboxFileURL.path) {
           
            let fileURL = path.appendingPathComponent("BackupFile.zip")
            
            do {
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                    self.localRealm.beginWrite()
                    do {
                        try self.localRealm.writeCopy(toFile: (self.documentDirectoryPath()?.appendingPathComponent("default.realm"))!)
                        print("Success")
                    } catch {
                        print("Error backing up data")
                    }
                    self.localRealm.cancelWrite()
                    do {
                        let dataFromPath: Data = try Data(contentsOf: path.appendingPathComponent("name.txt")) // URL을 불러와서 Data타입으로 초기화
                        let text: String = String(data: dataFromPath, encoding: .utf8) ?? "문서없음" // Data to String
                        print(text) // 출력
                        UserDefaults.standard.set(text, forKey: "filename")
                    } catch let e {
                        print(e.localizedDescription)
                    }
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
            
        } else {
            do {
                try FileManager.default.copyItem(at: selectedFileURL, to: sandboxFileURL)
                
                let fileURL = path.appendingPathComponent("BackupFile.zip")
                
                try Zip.unzipFile(fileURL, destination: path, overwrite: true, password: nil, progress: { progress in
                    print("progress: \(progress)")
                }, fileOutputHandler: { unzippedFile in
                    print("unzippedFile: \(unzippedFile)")
                    self.showAlertMessage(title: "복구가 완료되었습니다.")
                    self.localRealm.beginWrite()
                    do {
                        try self.localRealm.writeCopy(toFile: (self.documentDirectoryPath()?.appendingPathComponent("default.realm"))!)
                        print("Success")
                    } catch {
                        print("Error backing up data")
                    }
                    self.localRealm.cancelWrite()
                    do {
                        let dataFromPath: Data = try Data(contentsOf: path.appendingPathComponent("name.txt")) // URL을 불러와서 Data타입으로 초기화
                        let text: String = String(data: dataFromPath, encoding: .utf8) ?? "문서없음" // Data to String
                        print(text) // 출력
                        UserDefaults.standard.set(text, forKey: "filename")
                    } catch let e {
                        print(e.localizedDescription)
                    }
                })
                
            } catch {
                showAlertMessage(title: "압축 해제에 실패했습니다.")
            }
        }
        
    }
}

