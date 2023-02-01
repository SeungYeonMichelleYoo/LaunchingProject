//
//  HistoryDiaryView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/16.
//

import UIKit
import SnapKit

class HistoryDiaryView: BaseView {
    
    var placeList: [String] = ["주방", "옷장", "욕실", "신발장", "책상", "아이방", "기타"]

    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "오늘은 어떤 장소를\n정리했나요?"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        return label
    }()

    lazy var pickerView: UIPickerView = {
        let view = UIPickerView()
        return view
    }()
    
    //MARK: - textField (평소: hidden 이었다가 '기타' pickerview로 선택시 나타남)
    lazy var textField: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.placeholder = "장소를 입력해주세요"
        return view
    }()
    
    lazy var nextButton: UIButton = {
        let view = UIButton()
        view.setTitle("다음", for: .normal)
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 18)
        view.tintColor = .white
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.backgroundColor = Constants.BaseColor.pointcolor
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [placeLabel, pickerView, textField, nextButton].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {

        //MARK: - placeLabel
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(30)
        }
        
        //MARK: - pickerView
        pickerView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
        }
        
        //MARK: - textField
        textField.snp.makeConstraints { make in
            make.top.equalTo(pickerView.snp.bottom).offset(4)
            make.centerX.equalTo(pickerView)
            make.width.equalTo(300)
            make.height.equalTo(50)
        }
        
        //MARK: - nextButton
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
    }
}

