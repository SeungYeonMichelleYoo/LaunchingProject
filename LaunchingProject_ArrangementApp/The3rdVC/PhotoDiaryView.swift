//
//  PhotoDiaryView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/16.
//

import UIKit
import SnapKit

class PhotoDiaryView: BaseView {

    //MARK: - placeLabel
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.text = "오늘 정리된 곳의\n사진을 등록해보아요~"
        label.textColor = UIColor.black
        label.font = UIFont.systemFont(ofSize: 26, weight: .heavy)
        return label
    }()
    
    //MARK: - imageView
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "camera")
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.clipsToBounds = true
        return view
    }()

    //MARK: - okButton
    lazy var okButton: UIButton = {
        let view = UIButton()
        view.setTitle("완료", for: .normal)
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
        [placeLabel, imageView, okButton].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        
        //MARK: - placeLabel
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(30)
        }
        
        //MARK: - image
        imageView.snp.makeConstraints { make in
            make.top.equalTo(placeLabel.snp.bottom).offset(50)
            make.centerX.equalToSuperview()
            make.width.equalTo(300)
            make.height.equalTo(250)
        }
        
        //MARK: - nextButton
        okButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(50)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(300)
        }
    }
}

