//
//  BeforeAfterView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//

import UIKit
import SnapKit

class BeforeAfterTableViewCell: UITableViewCell {

    //MARK: - collectionview (사진 목록)
    let collectionView: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: imageCollectionViewLayout())
        view.backgroundColor = Constants.BaseColor.background
        return view
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
        
        self.contentView.addSubview(collectionView)
        collectionView.register(BeforeAfterCollectionViewCell.self, forCellWithReuseIdentifier: "BeforeAfterCollectionViewCell")

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(contentView)
        }
    }
    
    static func imageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let itemSpacing : CGFloat = 8
        let myWidth : CGFloat = UIScreen.main.bounds.width * 0.4
        let myHeight : CGFloat = UIScreen.main.bounds.width * 0.3 + 20
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        return layout
    }
}

