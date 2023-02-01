//
//  YoutubeViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//
import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
import Kingfisher

class YoutubeViewController: BaseViewController {
    
    var list: [YoutubeSectionModel] = []
    var fixedList: [YoutubeSectionModel] = []
    
    var menuList: [String] = ["전체", "냉장고", "신발장", "아이방", "옷장", "욕실", "주방", "책상", "기타"]
    var photoList: [String] = ["broom", "fridge", "shoes", "baby", "closet", "bath", "kitchen", "desk", "others"]
    var colorList: [Int] = [0xE4E8EB, 0xD8E5EE, 0xBACBDC, 0xDAD4D0, 0xEFEBE8]
    
    var selectedIndex: Int = 0
    
    //MARK: - collectionview (사진 목록 1열 가로로)
    let collectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 20
        let itemSpacing : CGFloat = 20
        
        let myWidth = 85
        let myHeight = 116
        
        layout.scrollDirection = .horizontal
        
        layout.sectionInset = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)
        layout.itemSize = CGSize(width: myWidth, height: myHeight)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = Constants.BaseColor.background
        return cv
    }()
    
    //MARK: - mainTableView
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = Constants.BaseColor.background
        return tableview
    }()
    
    //MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "정리 꿀팁 영상 추천"
        
        view.addSubview(collectionView)
        view.addSubview(mainTableView)
        
        setupCollectionView()
        setupTableView()
        requestYoutubeInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "isSecondVCLoaded") && !fixedList.isEmpty {
            reloadAllSection()
            self.navigationItem.title = "정리 꿀팁 영상 추천"
            UserDefaults.standard.set(true, forKey: "isSecondVCLoaded")
        }
    }
    
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(YoutubeCollectionViewCell.self, forCellWithReuseIdentifier: "YoutubeCollectionViewCell")
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(4)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(120)
        }
    }
    
    func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(YoutubeTableViewCell.self, forCellReuseIdentifier: "YoutubeTableViewCell")
        mainTableView.separatorStyle = .none
        mainTableView.showsVerticalScrollIndicator = false
        
        mainTableView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
            make.top.equalTo(collectionView.snp.bottom).offset(18)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        //section 뒤 배경 없애기
        mainTableView.backgroundView = nil
    }
    
    //MARK: - 섹션에 해당하는 테이블 각각 불러오기
    func reloadBySection(title: String) {
        list = []
        //for section in fixedList
        for i in 0...fixedList.count - 1 {
            let section = fixedList[i]
            if (section.sectionTitle == title) {
                list.append(section)
                break
            }
        }
        mainTableView.reloadData()
    }
    //MARK: - '전체' 불러오기
    func reloadAllSection() {
        list = []
        for section in fixedList {
            list.append(section)
            
        }
        mainTableView.reloadData()
    }
    
    func requestYoutubeInfo() {
        let url = "http://52.79.128.100/api/youtube_list.php"
        AF.request(url, method: .get).validate().responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                for youtube_section in json["section_list"].arrayValue {
                    let section_title = youtube_section["section"].stringValue
                    var youtube_list: [YoutubeModel] = []
                    for youtube in youtube_section["youtube_list"].arrayValue {
                        let youtube_section = youtube["section"].stringValue
                        let youtube_link = youtube["link"].stringValue
                        let youtube_title = youtube["title"].stringValue
                        let short_content = youtube["short_content"].stringValue
                        let youtube_content = youtube["content"].stringValue
                        let thumbnail = youtube["thumbnail"].stringValue
                        let data = YoutubeModel(thumbnail: thumbnail, youtubeTitle: youtube_title, youtubeContent: youtube_content, shortContent: short_content, youtubeSection: youtube_section, youtubeURL: youtube_link)
                        youtube_list.append(data)
                    }
                    var section = YoutubeSectionModel(sectionTitle: section_title, youtubeList: youtube_list)
                    self.list.append(section)
                    self.fixedList.append(section)
                }
                
                self.mainTableView.reloadData()
                
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

extension YoutubeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "YoutubeCollectionViewCell", for: indexPath) as? YoutubeCollectionViewCell else {
            
            return UICollectionViewCell()
        }
        
        if indexPath.item == selectedIndex {
            cell.placeImg.layer.shadowColor = UIColor.black.cgColor
            cell.placeImg.layer.masksToBounds = false
            cell.placeImg.layer.shadowOffset = CGSize(width: 4, height: 4)
            cell.placeImg.layer.shadowRadius = 5
            cell.placeImg.layer.shadowOpacity = 0.3
        } else {
            cell.placeImg.layer.shadowColor = UIColor.white.cgColor
        }
        cell.backgroundColor = Constants.BaseColor.background
        cell.placeImg.backgroundColor = UIColor(rgb: colorList[indexPath.item % colorList.count])
        cell.logoImg.image = UIImage(named: photoList[indexPath.item])
        cell.placeLabel.text = menuList[indexPath.item]
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        collectionView.reloadData()
        if indexPath.item == 0 {
            reloadAllSection()
            self.navigationItem.title = "정리 꿀팁 영상 추천"
        } else {
            reloadBySection(title: "\(menuList[indexPath.item])")
            self.navigationItem.title = "\(menuList[indexPath.item]) 정리 꿀팁 영상 추천"
        }
    }
}


//MARK: - tableview 관련
extension YoutubeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].youtubeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "YoutubeTableViewCell", for: indexPath) as! YoutubeTableViewCell
        let youtube = list[indexPath.section].youtubeList
        cell.titleLabel.text = youtube[indexPath.row].youtubeTitle
        cell.contentLabel.text = youtube[indexPath.row].shortContent
        cell.contentLabel.numberOfLines = 0
        
        let thumbnailUrl = URL(string: youtube[indexPath.row].thumbnail)
        cell.image.kf.setImage(with: thumbnailUrl)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(false, forKey: "isYoutubeLoaded")
        let vc = YoutubeWebViewController()
        let youtubeData = self.list[indexPath.section].youtubeList[indexPath.row]
        vc.youtubeData = youtubeData
        let place = youtubeData.youtubeSection
        let indexFromMenuList = menuList.firstIndex(where: {$0 == place})
        vc.placeImg.image = UIImage(named: photoList[indexFromMenuList!])
        
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
