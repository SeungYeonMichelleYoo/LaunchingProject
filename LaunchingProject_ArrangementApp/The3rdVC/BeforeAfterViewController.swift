//
//  BeforeAfterViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//
import UIKit
import SnapKit
import RealmSwift


class BeforeAfterViewController: BaseViewController {
    
    var tasks: Results<UserPhotoDiary>!
    let repository = UserPhotoDiaryListRepository()
    
    var placeSectionList: [String] = []
    
    var totalList: [Results<UserPhotoDiary>] = []
    
    var pickedPlace = ""
    
    let exampleImg = UIImageView()
    let exampleLabel = UILabel()
    
        
    //필터링 되어 나온 이미지
    var fetchedImage: String = ""
    
    var userPhotoDiary: UserPhotoDiary!
    
    //for adding gesture recognizer
    var statusImageView: UIImageView!
    var zoomImageView: UIImageView!
    var blackBackgroundView: UIView!
    var closeButton: UIButton!
    var navBarCoverView: UIView!
    var dateLabel: UILabel!
    var date: String!
    var deleteButton: UIButton!
    
    //MARK: - mainTableView
    lazy var mainTableView: UITableView = {
        let tableview = UITableView()
        tableview.backgroundColor = Constants.BaseColor.background
        return tableview
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "나만의 비포 & 애프터"
        
        repository.resetLocalRealm()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(plusbuttonClicked))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        view.addSubview(mainTableView)
        
        setupTableView()
        
        mainTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(8)
        }
    
        exampleImg.frame = CGRect(x: 10, y: 80, width: view.frame.width - 20, height: 400)
        exampleImg.image = UIImage(named: "VC4example")
        exampleImg.contentMode = .scaleAspectFit
        view.addSubview(exampleImg)
        
        exampleLabel.frame = CGRect(x: 20, y: 510, width: view.frame.width - 20, height: 50)
        exampleLabel.numberOfLines = 0
        exampleLabel.text = "위와 같이 나만의 비포 & 애프터를 만들어볼까요 ^^?"
        exampleLabel.textColor = .gray
        view.addSubview(exampleLabel)
        
        exampleImg.isHidden = totalList.count != 0
        exampleLabel.isHidden = totalList.count != 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        repository.resetLocalRealm()
        placeSectionList = repository.fetchSectionHeader()
        totalList = []
        for place in placeSectionList {
            print(place)
            totalList.append(repository.fetchFilterbyPlace(place: place))
        }
        mainTableView.reloadData()
        
        //MARK: - firstUser 처음 사용자에게 예시 화면
        exampleImg.isHidden = totalList.count != 0
        exampleLabel.isHidden = totalList.count != 0
        
        guard let data = UserDefaults.standard.data(forKey: "beforeAfterVC") else { return } //이미지가 있는지 없는지 판단. 있는 경우 아래 코드 실행, but 없다면 return
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data) //문자를 이미지로 변환
        BeforeAfterCollectionViewCell().historyImg.image = UIImage(data: decoded)
        
        UserDefaults.standard.removeObject(forKey: "beforeAfterVC")
    }
    
    //MARK: - 화면 전환 (비포 & 애프터 사진 등록 화면으로 이동)
    @objc func plusbuttonClicked() {
        //extension transition - 리팩토링
        let navi = UINavigationController(rootViewController: HistoryDiaryViewController())
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true)
    }
    
    func setupTableView() {
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.register(BeforeAfterTableViewCell.self, forCellReuseIdentifier: "BeforeAfterTableViewCell")
        
        //section 뒤 배경 없애기
        mainTableView.backgroundView = nil
        mainTableView.backgroundColor = .clear
        mainTableView.separatorStyle = .none
        mainTableView.showsVerticalScrollIndicator = false
    }
}

//MARK: - tableview 관련
extension BeforeAfterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return placeSectionList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return placeSectionList[section]
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeforeAfterTableViewCell", for: indexPath) as! BeforeAfterTableViewCell
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.showsHorizontalScrollIndicator = false
        cell.collectionView.tag = indexPath.section
        cell.collectionView.addGestureRecognizer(getPressGesture())
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
    
}

extension BeforeAfterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("COLLECTIONVIEW SECTION - row: \(collectionView.tag), totalList count: \(totalList.count)")
        print(totalList[collectionView.tag])
        print("COLLECTIONVEIW SECTION - count: \(totalList[collectionView.tag].count)")
        return totalList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //        let totalList = repository.fetchFilterbyPlace(place: placeSectionList[collectionView.tag])
        print("COLLECTIONVIEW CELL - row: \(collectionView.tag), index: \(indexPath.item)")
        print("COLLECTIONVIEW CELL - count:\(totalList[collectionView.tag].count) ")
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BeforeAfterCollectionViewCell", for: indexPath) as? BeforeAfterCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let photoDiary = totalList[collectionView.tag][indexPath.item]
        
        cell.historyImg.image = loadImageFromDocument(fileName: "\(photoDiary.objectId)_1.jpg")
        cell.dateLabel.text = photoDiary.regDate.formatted("yyyy-MM-dd")
        
        return cell
    }
}

extension BeforeAfterViewController {
    
    fileprivate func getPressGesture() -> UITapGestureRecognizer {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handlePress(gestureRecognizer:)))
        return tap
        //        view.addGestureRecognizer(tap)
    }
    
    @objc func handlePress(gestureRecognizer: UITapGestureRecognizer) {
        let location = gestureRecognizer.location(in: gestureRecognizer.view)
        let collectionView = gestureRecognizer.view as! UICollectionView
        let tableViewIndex = collectionView.tag
        if let indexPath = collectionView.indexPathForItem(at: location) { //손가락 tap한 부분 = location
            userPhotoDiary = totalList[tableViewIndex][indexPath.item]
            statusImageView = UIImageView(image: loadImageFromDocument(fileName: "\(totalList[tableViewIndex][indexPath.item].objectId)_1.jpg")!)
            date = totalList[tableViewIndex][indexPath.item].regDate.formatted("yyyy-MM-dd")
            animateImageView(img: statusImageView, date: date)
        }
    }
    
    func animateImageView(img: UIImageView, date: String) {
        self.statusImageView = img //현재 이미지 = img
        let startingFrame = img.frame //이미지는 컬렉션뷰셀부터 시작됨
        img.alpha = 0
        
        blackBackgroundView = UIView()
        blackBackgroundView.frame = self.view.frame
        blackBackgroundView.backgroundColor = UIColor.black
        view.addSubview(blackBackgroundView)
        blackBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
        zoomImageView = UIImageView()
        zoomImageView.frame = CGRect(x: 0, y: 0, width: view.frame.width / 2, height: view.frame.width / 2)
        zoomImageView.image = img.image
        zoomImageView.isUserInteractionEnabled = true
        view.addSubview(zoomImageView)
        
        navBarCoverView = UIView()
        navBarCoverView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 80)
        navBarCoverView.backgroundColor = UIColor.black
        navBarCoverView.alpha = 0
        view.addSubview(navBarCoverView)
        
        closeButton = UIButton()
        closeButton.frame = CGRect(x: 10, y: 90, width: 30, height: 30)
        closeButton.setImage(UIImage(systemName:"xmark.circle.fill"), for: .normal)
        closeButton.tintColor = .white
        view.addSubview(closeButton)
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
        
        deleteButton = UIButton()
        deleteButton.frame = CGRect(x: view.frame.width - 40, y: 90, width: 30, height: 30)
        deleteButton.setImage(UIImage(systemName:"trash.fill"), for: .normal)
        deleteButton.tintColor = .red
        view.addSubview(deleteButton)
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imgDeleteBtnClicked)))
        
        dateLabel = UILabel()
        dateLabel.frame = CGRect(x: 10, y: zoomImageView.frame.height + 440, width: 150, height: 30)
        dateLabel.text = date
        dateLabel.textColor = .white
        view.addSubview(dateLabel)
        
        TabbarViewController().tabBar.isHidden = true
        
        let centeredX = (view.frame.width - zoomImageView.frame.width) / 2
        zoomImageView.transform = CGAffineTransform(translationX: centeredX, y: 300)
        
        //MARK: - zoom in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y = UIScreen.main.bounds.height * 0.25
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 400)
            self.blackBackgroundView.alpha = 0.8
            self.navBarCoverView.alpha = 0.5
            self.tabBarController?.tabBar.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            self.navigationController?.navigationBar.barTintColor = .darkGray
            self.navigationController?.navigationBar.alpha = 0.99
        })
    }
    
    @objc func zoomOut() {
        let startingFrame = statusImageView.frame
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBackgroundView.alpha = 0
        }) { (didComplete) -> Void in
            self.zoomImageView.removeFromSuperview()
            self.blackBackgroundView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.statusImageView?.alpha = 1
            self.closeButton.removeFromSuperview()
            self.dateLabel.removeFromSuperview()
            self.deleteButton.removeFromSuperview()
            self.navBarCoverView.alpha = 0
            self.navigationController?.navigationBar.barTintColor = nil
            self.navigationController?.navigationBar.alpha = 1
            self.tabBarController?.tabBar.isHidden = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.plusbuttonClicked))
            self.navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.pointcolor
        }
    }
    
    @objc func imgDeleteBtnClicked() {
        //alert
        deleteBtnClicked()
    }
    
    func deleteBtnClicked() {
        let alert = UIAlertController(title: "정말 삭제하시겠습니까?", message: nil, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "예", style: .default, handler : {action in self.deletePressed()} )
        let cancel = UIAlertAction(title: "아니요", style: .destructive, handler : nil)
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func deletePressed() {
        zoomOut()
        
        //realm에서 삭제
        repository.delete(data: userPhotoDiary)
        
        //tableReload
        placeSectionList = repository.fetchSectionHeader()
        totalList = []
        for place in placeSectionList {
            print(place)
            totalList.append(repository.fetchFilterbyPlace(place: place))
        }
        print("TOTALLIST COUNT : \(totalList.count)")
        mainTableView.reloadData()
        
        exampleImg.isHidden = totalList.count != 0
        exampleLabel.isHidden = totalList.count != 0
    }
}
