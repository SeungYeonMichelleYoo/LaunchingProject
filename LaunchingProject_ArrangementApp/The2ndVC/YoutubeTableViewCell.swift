//
//  YoutubeTableViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//
import UIKit
import SnapKit

class YoutubeTableViewCell: UITableViewCell {
    
    //MARK: - image
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleToFill
        return img
    }()

    //MARK: - title
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    //MARK: - content
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.lightGray
        label.numberOfLines = 2
        label.font = UIFont.systemFont(ofSize: 14)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        image.image = nil
        titleLabel.text = nil
        contentLabel.text = nil
    }
    
    //MARK: - subview 추가 및 제약조건
    private func layout() {
        
        [image, titleLabel, contentLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.leadingMargin.equalTo(contentView.snp.leading).inset(8)
            make.top.equalTo(contentView.snp.top).inset(10)
            make.bottom.equalTo(contentView.snp.bottom).inset(10)
            make.width.equalTo(144)
            
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).inset(14)
            make.leadingMargin.equalTo(image.snp.trailing).offset(20)
            make.trailingMargin.equalTo(contentView.snp.trailing).inset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.leadingMargin.equalTo(image.snp.trailing).offset(20)
            make.trailingMargin.equalTo(contentView.snp.trailing).inset(4)
            make.height.equalTo(32)
        }
    }
}
