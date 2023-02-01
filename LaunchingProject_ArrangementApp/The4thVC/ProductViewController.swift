//
//  ProductViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/11.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON

class ProductViewController: BaseViewController {
    
    var section_name: String!
    
    var list: [ProductModel] = []

    let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 4
        
        let spacing : CGFloat = 4
        let myWidth = UIScreen.main.bounds.width * 0.29
        
        layout.scrollDirection = .vertical
        layout.sectionInset = .zero
        layout.itemSize = CGSize(width: myWidth, height: myWidth + 85)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Constants.BaseColor.background
        view.addSubview(collectionView)
        
        self.navigationItem.title = "\(section_name!) 정리 용품"
        setNavBackBtn()

        requestProductInfo()
        
        //MARK: -collectionView 등록
        collectionView.backgroundColor = Constants.BaseColor.background
        
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide).inset(UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 10))
        }
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: "ProductCollectionViewCell")
    }
        
    func requestProductInfo() {
        let parameters: Parameters = ["section_name": section_name!]
        let url = "http://52.79.128.100/api/product_list.php"
        AF.request(url, method: .get, parameters: parameters).validate().responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                for product in json["product_list"].arrayValue {
                    let product_section = product["section"].stringValue
                    let product_link = product["link"].stringValue
                    let product_title = product["product_name"].stringValue
                    let product_image = product["thumbnail"].stringValue
                    let product_price = product["price"].stringValue
                    let data = ProductModel(productThumbnail: product_image, productLink: product_link, productSection: product_section, productTitle: product_title, productPrice: product_price)
                    self.list.append(data)
                }
                //컬렉션뷰 갱신
                self.collectionView.reloadData()
                print(self.list)
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
extension ProductViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductCollectionViewCell", for: indexPath) as? ProductCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = Constants.BaseColor.background
        let thumbnailUrl = URL(string: list[indexPath.item].productThumbnail)
        DispatchQueue.global().async {
            let data = try? Data(contentsOf: thumbnailUrl!)
            if data != nil {
                DispatchQueue.main.async {
                    cell.productImg.image = UIImage(data: data!)
                }
            }
        }
        print(list[indexPath.row].productTitle)
        cell.productLabel.text = list[indexPath.item].productTitle
        cell.priceLabel.text = "₩ \(list[indexPath.item].productPrice)"
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailWebViewController()
        vc.productData = self.list[indexPath.item]
        vc.destinationURL = self.list[indexPath.item].productLink
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
