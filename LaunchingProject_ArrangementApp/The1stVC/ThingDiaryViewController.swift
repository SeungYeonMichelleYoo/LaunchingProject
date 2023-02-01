//
//  ThingDiaryViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/09.
//

import UIKit
import SnapKit
import RealmSwift
import IQKeyboardManagerSwift
import YPImagePicker

class ThingDiaryViewController: BaseViewController, UITextViewDelegate {
    
    var selectImageList: [UIImage] = []
    
    let repository = UserThingDiaryListRepository()
    var mainView = ThingDiaryView()
    
    var data: UserThingDiary = UserThingDiary()
    
    var writtenDate: Date!
    
    
    //MARK: - navigation 오른쪽 UIMenu 수정/삭제
    var menuItems: [UIAction] {
        return [
            UIAction(title: "메모 수정", image: UIImage(systemName: "pencil"), handler: { _ in self.modifyBtnClicked()}),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self.deleteBtnClicked()})
        ]
    }
    
    var new_menuItems: [UIAction] {
        return [
            UIAction(title: "완료", image: UIImage(systemName: "pencil"), handler: { _ in self.saveBtnClicked()}),
            UIAction(title: "삭제", image: UIImage(systemName: "trash"), attributes: .destructive, handler: { _ in self.deleteBtnClicked()})
        ]
    }
    
    var menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: menuItems)
    }
    
    
    var new_menu: UIMenu {
        return UIMenu(title: "", image: nil, identifier: nil, options: [], children: new_menuItems)
    }
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BaseColor.background
        
            mainView.textView.delegate = self
            mainView.bigImageView.image = loadImageFromDocument(fileName: "\(data.objectId)_1.jpg")
            mainView.textView.text = data.content

    
            self.navigationItem.title = "\(data.regDate.formatted("yyyy-MM-dd"))"
            if #available(iOS 14.0, *) {
                navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: menu)
                self.navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.textcolor
            } else {
                UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(completeButtonClicked)) //고쳐야됨
            }
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        
        self.navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        
        //MARK: - 카메라 이미지 클릭시 YPImagePicker 실행 / 수정화면에선 막아놓음. textView 수정도 같이 막음
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageViewClicked))
        if self.mainView.bigImageView.image == UIImage(named: "camera") {
            self.mainView.bigImageView.addGestureRecognizer(tapGesture)
            self.mainView.bigImageView.isUserInteractionEnabled = true
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        return changedText.count <= 16
    }
    
    //MARK: - UIMenu 수정 선택시
    func modifyBtnClicked() {
        self.mainView.textView.isEditable = true
        self.mainView.textView.becomeFirstResponder()
        textViewDidChange(self.mainView.textView)
    }
    func textViewDidChange(_ textView: UITextView) {
        //uimenu 수정 -> 완료버튼
        if #available(iOS 14.0, *) {
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: "ellipsis.circle"), primaryAction: nil, menu: new_menu)
            self.navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        } else {
            UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: #selector(completeButtonClicked)) //고쳐야됨
        }
    }
    func saveBtnClicked() {
        repository.modify(data: data, content: self.mainView.textView.text ?? "")
        self.dismiss(animated: true)
    }
    
    //MARK: - UIMenu 삭제 선택시
    func deleteBtnClicked() {
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : {action in self.deletePressed()} )
        let cancel = UIAlertAction(title: "아니요", style: .destructive, handler : nil)
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    func deletePressed()
    {
        repository.delete(data: data)
        self.dismiss(animated: true)
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
                        self.mainView.bigImageView.image = p.image
                    }
                    
                default:
                    print("")
                }
            }
            
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    //MARK: - 네비게이션 왼쪽 아이템- 뒤로가기 버튼 클릭시
    @objc func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
    //MARK: - 네비게이션 오른쪽 아이템- 완료 버튼 클릭시
    @objc func completeButtonClicked() {
        //nil 값일 때 (사용자가 이미지 선택하지 않은 경우 얼럿 메시지 띄워줌). 또는 그냥 토스트메시지 띄우는게 나을 수도 있음. 굳이 확인을 누르게할 필요 없으니깐.
            
        data.imageCount = selectImageList.count
        data.content = self.mainView.textView.text ?? ""
        data.regDate = Date()
        repository.addItem(data: data)
        
        self.dismiss(animated: true)
        
    }
}
