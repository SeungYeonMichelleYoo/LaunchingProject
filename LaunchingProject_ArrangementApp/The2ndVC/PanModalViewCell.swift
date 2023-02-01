//
//  PanModalView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/02.
//

import UIKit
import SnapKit

class PanModalViewCell: UITableViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
        label.text = "출처 및 고지 사항"
        label.textAlignment = .left
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15)
        label.textAlignment = .left
        return label
    }()
    
    //코드로 tableview짤 때(스토리보드 없이), 초기화 해야하는 이유: 인터페이스 빌더에서는 자동으로 초기화를 해주지만, 코드에서는 인터페이스 빌더를 사용하는게 아니기 때문
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        self.contentView.backgroundColor = Constants.BaseColor.background
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func layout() {
        [titleLabel, contentLabel].forEach {
            contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(contentView).inset(30)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel).offset(50)
            make.leading.trailing.equalTo(contentView).inset(30)
        }
    }
}
