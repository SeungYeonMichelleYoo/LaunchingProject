//
//  ProductCollectionViewCell.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/11.
//

import UIKit
import SnapKit

class ProductCollectionViewCell: UICollectionViewCell {
    
    lazy var productImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    lazy var productLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    lazy var priceLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 15)
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
        [productImg, productLabel, priceLabel].forEach {
            self.contentView.addSubview($0)
        }
        
        productImg.snp.makeConstraints { make in
            make.leading.top.equalTo(self.contentView)
            make.width.equalTo(UIScreen.main.bounds.width * 0.29)
            make.height.equalTo(UIScreen.main.bounds.width * 0.29)
        }
    
        productLabel.snp.makeConstraints { make in
            make.top.equalTo(productImg.snp.bottom).offset(6)
            make.leading.equalTo(productImg.snp.leading)
            make.width.equalTo(productImg.snp.width)
            make.height.equalTo(40)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(productLabel.snp.bottom).offset(4)
            make.leading.equalTo(productImg.snp.leading)
            make.width.equalTo(productImg.snp.width)
            make.height.equalTo(30)
        }
    }
}
