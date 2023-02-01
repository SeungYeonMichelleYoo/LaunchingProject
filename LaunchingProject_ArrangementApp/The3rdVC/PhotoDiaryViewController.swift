//
//  PhotoDiaryViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/16.
//

import UIKit
import SnapKit
import YPImagePicker

class PhotoDiaryViewController: BaseViewController {
    
    var selectImageList: [UIImage] = []
    
    let repository = UserPhotoDiaryListRepository()
    var mainView = PhotoDiaryView()
    
    var data: UserPhotoDiary = UserPhotoDiary()
    
    var pickedPlace = ""
    
    override func loadView() { //super.loadView 호출 금지
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BaseColor.background

        setNavBackBtn()
        
        if #available(iOS 15.0, *) {
            self.mainView.okButton.addTarget(self, action: #selector(okBtnClicked), for: .touchUpInside)
        } else {
            // Fallback on earlier versions
        }
        
        //MARK: - 카메라 이미지 클릭시 YPImagePicker 실행
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked))
        self.mainView.imageView.addGestureRecognizer(tapGesture)
        self.mainView.imageView.isUserInteractionEnabled = true
    }
    
    //MARK: - YPImagePicker 이미지 등록하기
    @objc func imageViewClicked() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1 // 최대 선택 가능한 사진 개수 제한
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)
        
        let picker = YPImagePicker(configuration: config)
        print("success")
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            // 여러 이미지를 넣어주기 위해 하나씩 넣어주는 반복문
            for item in items {
                switch item {
                    // 이미지만 받기때문에 photo case만 처리
                case .photo(let p):
                    // 이미지를 해당하는 이미지 배열에 넣어주는 code
                    self.selectImageList = [] //사진 변경 시 초기화
                    self.selectImageList.append(p.image)
                    if self.selectImageList.count == 1 { //첫번째 사진을 등록했을 때 (selecImageList[0]) | 첫번째 사진을 메인으로 등록하게 됨
                        self.mainView.imageView.image = p.image
                    }
                    
                default:
                    print("")
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
        
    //MARK: - okBtn Clicked
    @available(iOS 15.0, *)
    @objc func okBtnClicked() {
        //nil 값일 때 (사용자가 이미지 선택하지 않은 경우 얼럿 메시지 띄워줌). 또는 그냥 토스트메시지 띄우는게 나을 수도 있음. 굳이 확인을 누르게할 필요 없으니깐.
        if selectImageList.count == 0 {
            showAlertMessage(title: "사진을 선택해주세요.", button: "확인")
            return
        }
        
        for i in 1...selectImageList.count {
            saveImageToDocument(fileName: "\(data.objectId)_\(i).jpg", image: mainView.imageView.image!)
        }
        data.imageCount = selectImageList.count
        data.place = pickedPlace
        data.regDate = Date()
        repository.addItem(data: data)
        
        self.dismiss(animated: true)
    }
    
}
