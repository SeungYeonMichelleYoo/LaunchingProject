//
//  HistoryDiaryViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/11.
//

import UIKit
import SnapKit
import IQKeyboardManagerSwift
import YPImagePicker

class HistoryDiaryViewController: BaseViewController {
    
    let repository = UserPhotoDiaryListRepository()
    
    var placeiconList: [String] = ["fridge", "kitchen", "closet", "bath", "shoes", "desk", "baby", "others"]
    
    var placeList: [String] = ["냉장고", "주방", "옷장", "욕실", "신발장", "책상", "아이방", "기타"]
    
    var mainView = HistoryDiaryView()
    
    var selectImageList: [UIImage] = []
    
    var selectedRow = 0
    
    var pickedPlace = ""
    
    var data: UserPhotoDiary = UserPhotoDiary()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        
        self.mainView.nextButton.addTarget(self, action: #selector(nextBtnClicked), for: .touchUpInside)
        
        self.mainView.pickerView.delegate = self
        self.mainView.pickerView.dataSource = self
        
        self.mainView.textField.isHidden = true
        self.mainView.textField.delegate = self
    }
    
    
    //MARK: - Navigation left Btn clicked
    @objc func backButtonClicked() {
        self.dismiss(animated: true)
    }
    
    //MARK: - nextBtn Clicked
    @objc func nextBtnClicked() {
        if selectedRow == 7 && mainView.textField.text == "" {
            showAlertMessage(title: "장소를 입력해주세요.", button: "확인")
        } else { // ****** 카메라로 바로 넘어가게끔.
            imageViewClicked()
            self.pickedPlace = selectedRow == 7 ? mainView.textField.text! : placeList[selectedRow]
        }
    }
    
    //MARK: - YPImagePicker 이미지 등록하기
    func imageViewClicked() {
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
                    print(self.selectImageList.count)
                    if self.selectImageList.count == 1 { //첫번째 사진을 등록했을 때 (selecImageList[0]) | 첫번째 사진을 메인으로 등록하게 됨
                        print("imageViewClicked returned")
                        self.saveImage(img: p.image)
                        print("imageViewClicked returned ended")
                    }
                default:
                    print("")
                }
            }
            picker.dismiss(animated: false, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    func saveImage(img: UIImage) {
        for i in 1...selectImageList.count {
            saveImageToDocument(fileName: "\(data.objectId)_\(i).jpg", image: img)
        }
        data.imageCount = selectImageList.count
        data.place = pickedPlace
        data.regDate = Date()
        repository.addItem(data: data)
        
        guard let data = img.jpegData(compressionQuality: 1.0) else { return }
        let encoded = try! PropertyListEncoder().encode(data) //이미지를 문자로 변환해서 저장
        UserDefaults.standard.set(encoded, forKey: "beforeAfterVC")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let data = UserDefaults.standard.data(forKey: "beforeAfterVC") else { return } //이미지가 있는지 없는지 판단. 있는 경우 아래 코드 실행, but 없다면 return
        self.dismiss(animated: true)
    }


//MARK: - pickerView subview
override func viewWillLayoutSubviews() {
    selectedPickerViewUICustom()
}

func selectedPickerViewUICustom() {
    mainView.pickerView.subviews[1].backgroundColor = .clear
    
    let upLine = UIView(frame: CGRect(x: 15, y: 0, width: 250, height: 0.8))
    let underLine = UIView(frame: CGRect(x: 15, y: 60, width: 250, height: 0.8))
    
    upLine.backgroundColor = Constants.BaseColor.placeholder
    underLine.backgroundColor = Constants.BaseColor.placeholder
    
    mainView.pickerView.subviews[1].addSubview(upLine)
    mainView.pickerView.subviews[1].addSubview(underLine)
}
}
extension HistoryDiaryViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        //        let view = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        //        let placeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 40))
        //        placeLabel.text = placeList[row]
        //        placeLabel.textAlignment = .center
        //        placeLabel.font = UIFont.systemFont(ofSize: 28, weight: .light)
        //        placeLabel.textColor = Constants.BaseColor.textcolor
        //
        //        view.addSubview(placeLabel)
        //        return view
        
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: pickerView.bounds.width - 50, height: 40))
        
        let myImageView = UIImageView(frame: CGRect(x: 60, y: 0, width: 30, height: 40))
        
        let placeLabel = UILabel(frame: CGRect(x: 110, y: 0, width: pickerView.bounds.width - 90, height: 40 ))
        
        myImageView.image = UIImage(named: placeiconList[row])
        placeLabel.font = UIFont.boldSystemFont(ofSize: 22)
        placeLabel.textColor = UIColor.black
        placeLabel.text = placeList[row] as? String
        myView.addSubview(placeLabel)
        myView.addSubview(myImageView)
        
        return myView
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placeList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("select=\(row)")
        selectedRow = row
        mainView.textField.isHidden = row != 7
        row == 7 ? mainView.textField.becomeFirstResponder() : mainView.textField.resignFirstResponder()
    }
}

extension HistoryDiaryViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.mainView.textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = self.mainView.textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let changedText = currentText.replacingCharacters(in: stringRange, with: string)
        print(changedText.count)
        return changedText.count <= 10
    }
}
