//
//  SettingView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/03.
//
import UIKit
import SnapKit

class SettingView: BaseView {
    
    //MARK: - mainTableView
    lazy var mainTableView: UITableView = {
        let tableview = UITableView(frame: .zero, style: .insetGrouped)
        tableview.separatorStyle = .singleLine
        tableview.separatorInset = UIEdgeInsets(top: 0, left: 14, bottom: 0, right: 14)
//        tableview.separatorColor = Constants.BaseColor.background
        return tableview
    }()
      
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [mainTableView].forEach {
            self.addSubview($0)
        }
    }
        override func setConstraints() {
        
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide)
            make.leading.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(8)
            make.trailing.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(8)
            make.bottom.equalTo(self.safeAreaLayoutGuide.snp.bottom).inset(30)
        }
    }
    
    
}

