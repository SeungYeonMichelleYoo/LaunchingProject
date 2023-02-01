//
//  BeforeAfterCollectionViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/15.
//
import UIKit
import SnapKit

class BeforeAfterCollectionViewCell: UICollectionViewCell {
    var index: Int!

    //MARK: - imageView
    lazy var historyImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.isUserInteractionEnabled = true
        return view
    }()
    
    //MARK: - 등록 날짜
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = Constants.BaseColor.textcolor
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.cellSetting()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cellSetting() {
        self.backgroundColor = Constants.BaseColor.background
        [historyImg, dateLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        historyImg.snp.makeConstraints { make in
            make.top.leading.equalTo(contentView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
            make.height.equalTo(UIScreen.main.bounds.width * 0.3)
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(historyImg.snp.bottom).offset(4)
            make.leading.equalTo(historyImg.snp.leading).offset(4)
            make.width.equalTo(UIScreen.main.bounds.width * 0.4)
        }
    }
}
