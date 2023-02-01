//
//  ShopViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ShopViewController: BaseViewController {
    var sectionList: [ProductSectionModel] = []
    
    var photolist: [String] = ["fridge", "kitchen", "closet", "bath", "shoes", "desk", "baby", "others"]
    var placelist: [String] = ["냉장고", "주방", "옷장", "욕실", "신발장", "책상", "아이방", "기타"]
    var colorList: [Int] = [0xE4E8EB, 0xD8E5EE, 0xBACBDC, 0xDAD4D0, 0xEFEBE8]
    var list: [String] = []
    
    var logoImgList: [String] = [""]
    
    var selectedIndexPath: IndexPath!
    
    //MARK: - collectionview (사진 목록 2열로)
    let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        let itemSpacing : CGFloat = 24
        
        let myWidth = (UIScreen.main.bounds.width - itemSpacing * 3) / 2
        
        layout.minimumLineSpacing = 40
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 35, left: 24, bottom: 0, right: itemSpacing)
        layout.itemSize = CGSize(width: myWidth , height: myWidth + 38)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "정리 아이템 추천"
 
        view.addSubview(collectionView)

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ShopCollectionViewCell.self, forCellWithReuseIdentifier: "ShopCollectionViewCell")
        
        self.collectionView.backgroundColor = Constants.BaseColor.background
        self.collectionView.showsVerticalScrollIndicator = false
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        collectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTouchDown(gestureRecognizer:))))
        
        requestProductInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if selectedIndexPath != nil {
            (collectionView.cellForItem(at: selectedIndexPath) as? ShopCollectionViewCell)!.placeLabel.textColor = .black
        }
    }
        
    func requestProductInfo() {
        let url = "http://52.79.128.100/api/product_section_list.php"
        AF.request(url, method: .get).validate().responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for product_section in json["section_list"].arrayValue {
                    let section_name = product_section.stringValue
                    self.list.append(section_name)
                }
                self.collectionView.reloadData()
                print(self.sectionList)
                
            case .failure(let error):
                print(error)
                let alertController = UIAlertController(
                    title: "네트워크에 접속할 수 없습니다.",
                    message: "네트워크 연결 상태를 확인해주세요.",
                    preferredStyle: .alert
                )
                
                let endAction = UIAlertAction(title: "종료", style: .destructive) { _ in
                    // 앱 종료
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                
                let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
                    // 설정앱 켜주기
                    guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                }
                
                alertController.addAction(endAction)
                alertController.addAction(confirmAction)
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

//MARK: - CollectionView
extension ShopViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return photolist.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShopCollectionViewCell", for: indexPath) as? ShopCollectionViewCell else {
           return UICollectionViewCell()
       }
       
       cell.logoImg.image = UIImage(named: "\(photolist[indexPath.item])")
       cell.image.backgroundColor = UIColor(rgb: colorList[indexPath.item % colorList.count])
       cell.placeLabel.text = "\(placelist[indexPath.item])"
       return cell
   }
   

    @objc func didTouchDown(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let collectionView = gestureRecognizer.view as! UICollectionView
        if let indexPath = collectionView.indexPathForItem(at: location) {
            selectedIndexPath = indexPath
            (collectionView.cellForItem(at: indexPath) as? ShopCollectionViewCell)!.placeLabel.textColor = Constants.BaseColor.pointcolor
                let vc = ProductViewController()
                vc.section_name = self.list[indexPath.item]
                self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
