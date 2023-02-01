//
//  ShopCollectionViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/27.
//

import UIKit
import SnapKit

class ShopCollectionViewCell: UICollectionViewCell {
    
    lazy var image: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = Constants.Design.cornerRadius
        img.clipsToBounds = true
        return img
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
        label.font = UIFont.boldSystemFont(ofSize: 18)
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
        [image, logoImg, placeLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        image.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalToSuperview().inset(20)
        }
        
        logoImg.snp.makeConstraints { make in
            make.center.equalTo(image)
            make.width.equalTo(40)
            make.height.equalTo(40)
        }
        
        placeLabel.snp.makeConstraints { make in
            make.top.equalTo(image.snp.bottom).offset(10)
            make.leading.equalTo(image.snp.leading)
            make.width.equalTo(image.snp.width)
        }
    }
}
