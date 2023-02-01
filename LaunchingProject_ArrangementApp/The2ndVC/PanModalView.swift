//
//  PanModalView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/02.
//

import UIKit
import SnapKit

class PanModalView: BaseView {
    
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = Constants.BaseColor.background
        tableview.separatorStyle = .none
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
        let myWidth = UIScreen.main.bounds.width - 8
        mainTableView.snp.makeConstraints { make in
            make.top.bottom.equalTo(self.safeAreaLayoutGuide)
//            make.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(4)
            make.width.equalTo(myWidth)
        }
    }
    
}
