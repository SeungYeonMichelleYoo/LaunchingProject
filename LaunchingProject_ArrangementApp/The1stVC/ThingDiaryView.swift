//
//  ThingDiaryView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/09.
//

import UIKit
import SnapKit

class ThingDiaryView: BaseView {
    
    //MARK: - imageView
    lazy var bigImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: "camera")
        view.contentMode = .scaleToFill
        view.layer.cornerRadius = Constants.Design.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    //MARK: - info Label
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.text = "남기고 싶은 메모(없으면 비워두셔도 좋아요~)"
        label.font = UIFont.boldSystemFont(ofSize: 15)
        return label
    }()
    
    //MARK: - textView
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.backgroundColor = Constants.BaseColor.background
        textView.layer.cornerRadius = Constants.Design.cornerRadius
        textView.isEditable = false
        return textView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [bigImageView, infoLabel, textView].forEach {
            self.addSubview($0)
        }
    }
    
    //MARK: - setConstraints()
    override func setConstraints() {
        
        bigImageView.snp.makeConstraints { make in
            make.top.equalTo(self.safeAreaLayoutGuide.snp.top).inset(20)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(40)
            make.trailingMargin.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(40)
            make.height.equalTo(UIScreen.main.bounds.height * 0.4)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(bigImageView.snp.bottom).offset(10)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(40)
            make.trailingMargin.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(40)
            make.height.equalTo(30)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(infoLabel.snp.bottom)
            make.leadingMargin.equalTo(self.safeAreaLayoutGuide.snp.leading).inset(40)
            make.trailingMargin.equalTo(self.safeAreaLayoutGuide.snp.trailing).inset(40)
            make.height.equalTo(UIScreen.main.bounds.height * 0.25)
        }

    }
}

