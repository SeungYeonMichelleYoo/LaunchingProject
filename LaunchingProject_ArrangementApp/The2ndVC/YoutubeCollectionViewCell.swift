//
//  YoutubeCollectionViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/27.
//

import UIKit
import SnapKit

class YoutubeCollectionViewCell: UICollectionViewCell {
    
    lazy var placeImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = 38
        view.clipsToBounds = true
        return view
    }()
    
    lazy var logoImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.backgroundColor = nil
        return view
    }()
    
    lazy var placeLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 15)
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
        [placeImg, logoImg, placeLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        placeImg.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalTo(8)
            make.height.equalTo(76)
            make.width.equalTo(76)
        }
        
        logoImg.snp.makeConstraints { make in
            make.edges.equalTo(placeImg).inset(20)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(placeImg.snp.bottom).offset(10)
            make.leading.equalTo(placeImg.snp.leading)
            make.width.equalTo(76)
        }
    }
}
