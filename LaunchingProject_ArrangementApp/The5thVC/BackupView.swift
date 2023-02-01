//
//  BackupView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/10.
//

import UIKit
import SnapKit

class BackupView: BaseView {
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "클라우드 저장소, 메일 등에 기록을 백업하여 \n핸드폰을 바꾸거나, 앱을 삭제했다가 다시 깔더라도 기존의 기록을 복구할 수 있어요."
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var backupButton: UIButton = {
        let view = UIButton()
        view.setTitle("백업", for: .normal)
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 18)
        view.tintColor = .white
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.backgroundColor = Constants.BaseColor.pointcolor
        return view
    }()
    
    lazy var restoreButton: UIButton = {
        let view = UIButton()
        view.setTitle("복원", for: .normal)
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
        [infoLabel, backupButton, restoreButton].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide).offset(30)
            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(30)
            make.height.equalTo(150)
        }
        
        let itemspacing: CGFloat = 16
        
        backupButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).offset(itemspacing)
            make.width.equalTo((UIScreen.main.bounds.width - itemspacing * 3)/2)
        }
        
        restoreButton.snp.makeConstraints { make in
            make.bottom.equalTo(self.safeAreaLayoutGuide).inset(50)
            make.leading.equalTo(backupButton.snp.leading).offset((UIScreen.main.bounds.width - itemspacing * 3)/2 + itemspacing)
            make.width.equalTo((UIScreen.main.bounds.width - itemspacing * 3)/2)
        }
    }
}

