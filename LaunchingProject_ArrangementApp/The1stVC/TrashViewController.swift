//
//  TrashViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/28.
//

import UIKit
import SnapKit
import RealmSwift
import YPImagePicker


class TrashViewController: BaseViewController, UIImagePickerControllerDelegate {
    
    var tasks: Results<UserThingDiary>!
    let repository = UserThingDiaryListRepository()
    
    var placeSectionList: [String] = ["기타", "옷장", "신발장", "책상", "주방", "아이방", "냉장고", "욕실"]
    var photoList: [String] = ["others", "closet", "shoes", "desk", "kitchen", "baby", "fridge", "bath"]
    var totalList: [Results<UserThingDiary>] = []
    
    var selectImageList: [UIImage] = []
    
    var colorList: [Int] = [0xE4E8EB, 0xD8E5EE, 0xBACBDC, 0xDAD4D0, 0xEFEBE8]
    
    var firstCellStatus: Bool = false
    
    var mainView = TrashView()

    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: -Navigation
        self.navigationItem.title = "1 일 1 물건 버리기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "camera"), style: .plain, target: self, action: #selector(plusbuttonClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        
        print("여기서 확인 -> \(documentDirectoryPath()?.path)")
        
        UserDefaults.standard.set(-1, forKey: "newPlace")
        
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil)
            for url in fileURLs {
                print(url.path)
            }
        } catch {
            print("Error while enumerating files \(documentsURL.path): \(error.localizedDescription)")
        }
    }
    
    func setupTableView() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.register(TrashTableViewCell.self, forCellReuseIdentifier: "TrashTableViewCell")
        
        mainView.mainTableView.backgroundView = nil
        mainView.mainTableView.backgroundColor = .clear
        mainView.mainTableView.showsVerticalScrollIndicator = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        repository.resetLocalRealm()
        tasks = repository.fetch()
        totalList = []
        for place in placeSectionList {
            totalList.append(repository.fetchFilterbyPlace(place: place))
        }
        
        setupTableView()
        mainView.mainTableView.reloadData()
        
        guard let data = UserDefaults.standard.data(forKey: "image4thingdiary") else { return } //이미지가 있는지 없는지 판단. 있는 경우 아래 코드 실행, but 없다면 return
        let decoded = try! PropertyListDecoder().decode(Data.self, from: data) //문자를 이미지로 변환
        let image = UIImage(data: decoded)
        
        let vc = MemoViewController()
        vc.bigImageView.image = image
        vc.selectImageList.append(image!)
//        vc.navigationItem.title = UserDefaults.standard.string(forKey: "newPlace")
        vc.selectedIndex = UserDefaults.standard.integer(forKey: "newPlace")
        let navi = UINavigationController(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        navi.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        self.present(navi, animated: true)
        
        UserDefaults.standard.removeObject(forKey: "image4thingdiary")
        UserDefaults.standard.set(-1, forKey: "newPlace")
    }
    
    //MARK: - 물건 사진 등록
    @objc func plusbuttonClicked() {
        
        imageViewClicked()
    }
    
    //MARK: - YPImagePicker 이미지 등록하기
    func imageViewClicked() {
        var config = YPImagePickerConfiguration()
        config.library.maxNumberOfItems = 1 // 최대 선택 가능한 사진 개수 제한
        config.library.mediaType = .photo // 미디어타입(사진, 사진/동영상, 동영상)
        
        let picker = YPImagePicker(configuration: config)
        print("success")
        
        picker.didFinishPicking { [unowned picker] items, cancelled in
            if cancelled {
                picker.dismiss(animated: true, completion: nil)
                return
            }
            
            // 여러 이미지를 넣어주기 위해 하나씩 넣어주는 반복문
            for item in items {
                switch item {
                    // 이미지만 받기때문에 photo case만 처리
                case .photo(let p):
                    // 이미지를 해당하는 이미지 배열에 넣어주는 code
                    self.selectImageList = [] //사진 변경 시 초기화
                    self.selectImageList.append(p.image)
                    print(self.selectImageList.count)
                    if self.selectImageList.count == 1 { //첫번째 사진을 등록했을 때 (selecImageList[0]) | 첫번째 사진을 메인으로 등록하게 됨
                        print("imageViewClicked returned")
                        self.saveImage(img: p.image)
                        print("imageViewClicked returned ended")
                    }
                default:
                    print("")
                }
            }
            picker.dismiss(animated: false, completion: nil)
        }
        present(picker, animated: true, completion: nil)
    }
    func saveImage(img: UIImage) {
        guard let data = img.jpegData(compressionQuality: 1.0) else { return }
        let encoded = try! PropertyListEncoder().encode(data) //이미지를 문자로 변환해서 저장
        UserDefaults.standard.set(encoded, forKey: "image4thingdiary")
    }
}

//MARK: - tableview 관련
extension TrashViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.black
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrashTableViewCell", for: indexPath) as! TrashTableViewCell
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.tag = indexPath.section
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension TrashViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if totalList[collectionView.tag].count == 0 {
            return 1 } else {
        return totalList[collectionView.tag].count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TrashCollectionViewCell", for: indexPath) as? TrashCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.plusBtn.isHidden = indexPath.item != 0
        cell.logoImg.isHidden = indexPath.item != 0
        
        if totalList[collectionView.tag].count == 0 {
            if indexPath.item == 0 {
                cell.trashImg.backgroundColor = UIColor(rgb: colorList[collectionView.tag % colorList.count])
                cell.logoImg.image = UIImage(named: photoList[collectionView.tag])
                cell.trashImg.image = nil
            }
            return cell
        } else {
            let thingDiary = totalList[collectionView.tag][indexPath.item]
            cell.trashImg.image = loadImageFromDocument(fileName: "\(thingDiary.objectId)_1.jpg")
            cell.logoImg.isHidden = true
            cell.plusBtn.isHidden = true
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item < totalList[collectionView.tag].count {
            let vc = ThingDiaryViewController()
            let navi = UINavigationController(rootViewController: vc)
            vc.data = totalList[collectionView.tag][indexPath.item]
            vc.mainView.infoLabel.isHidden = true
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        } else {
            let newPlace = collectionView.tag
            UserDefaults.standard.set(newPlace, forKey: "newPlace")
            imageViewClicked()
    }
}
}
