//
//  TrashTableViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/28.
//

import UIKit
import SnapKit

class TrashTableViewCell: UITableViewCell {
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        TrashCollectionViewCell().logoImg.image = nil
        TrashCollectionViewCell().trashImg.image = nil
    }
    
    //MARK: - subview 추가 및 제약조건
    private func layout() {
        self.contentView.addSubview(collectionView)
        collectionView.register(TrashCollectionViewCell.self, forCellWithReuseIdentifier: "TrashCollectionViewCell")

        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(contentView)
        }
        
        collectionView.showsHorizontalScrollIndicator = false
    }
    
    static func imageCollectionViewLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 8
        layout.minimumInteritemSpacing = 8
        
        let itemSpacing : CGFloat = 8
        let myWidth : CGFloat = 100
        let myHeight : CGFloat = 100
        
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        return layout
    }
}


