//
//  TrashCollectionViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/28.
//
import UIKit
import SnapKit

class TrashCollectionViewCell: UICollectionViewCell {
    var index: Int!

    lazy var trashImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = .gray
        return view
    }()
    
    lazy var logoImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = nil
        return view
    }()
    
    lazy var plusBtn: UIButton = {
        let view = UIButton()
        view.layer.cornerRadius = 8
        view.clipsToBounds = true
        view.setImage(UIImage(systemName: "plus"), for: .normal)
        view.tintColor = UIColor.white
        view.backgroundColor = UIColor.lightGray
        return view
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
        [trashImg, logoImg, plusBtn].forEach {
            self.contentView.addSubview($0)
        }
        
        trashImg.snp.makeConstraints { make in
            make.centerX.equalTo(contentView)
            make.top.equalTo(contentView)
            make.leading.trailing.equalTo(contentView)
            make.bottom.equalTo(contentView)
        }
        
        logoImg.snp.makeConstraints { make in
            make.center.equalTo(trashImg)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        plusBtn.snp.makeConstraints { make in
            make.leading.equalTo(logoImg.snp.trailing).inset(14)
            make.top.equalTo(logoImg.snp.bottom).inset(16)
            make.width.equalTo(16)
            make.height.equalTo(16)
        }
    }
}
