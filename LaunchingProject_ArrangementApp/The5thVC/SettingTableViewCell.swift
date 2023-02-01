//
//  SettingTableViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/03.
//

import UIKit
import SnapKit

class SettingTableViewCell: UITableViewCell {
    
    //MARK: - title
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        self.contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    //MARK: - subview 추가 및 제약조건
    private func layout() {
        
        [titleLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(contentView)
            make.leading.equalTo(contentView.snp.leading).inset(16)
            make.trailing.equalTo(contentView.snp.trailing).inset(16)
        }
    }
}

