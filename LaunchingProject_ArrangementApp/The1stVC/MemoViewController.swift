////
////  MemoViewController.swift
////  LaunchingProject_ArrangementApp
////
////  Created by SeungYeon Yoo on 2022/09/28.
////
//
import UIKit
import SnapKit
import IQKeyboardManagerSwift

class MemoViewController: BaseViewController {
    var selectImageList: [UIImage] = []
    
    let repository = UserThingDiaryListRepository()
    var data: UserThingDiary = UserThingDiary()
    
    var btnTitle: String = ""
    let btnList: [String] = ["기타", "옷장", "신발장", "책상", "주방", "아이방", "냉장고", "욕실"]
    
    var isEdited: Bool = false
    
    var clickedBtn: UIButton!
    
    var categorylist: [UIButton] = []
    var selectedIndex: Int = -1

    //기타, 옷장, 신발장, 책상, 주방, 아이방
    lazy var bigImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        return view
    }()
    
    lazy var othersBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "기타"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "others")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xE4E8EB)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()
    
    lazy var clothesBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "옷장"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "closet")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xD8E5EE)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()

    
    lazy var shoesBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "신발장"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "shoes")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xBACBDC)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()

    lazy var deskBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "책상"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "desk")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xDAD4D0)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()

    lazy var kitchenBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "주방"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "kitchen")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xEFEBE8)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()

    lazy var babyBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "아이방"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "baby")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xE4E8EB)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()
    
    lazy var fridgeBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "냉장고"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "fridge")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xD8E5EE)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()

    lazy var bathBtn: UIButton = {
        let view = UIButton()
        var config = UIButton.Configuration.filled()
        config.title = "욕실"
        config.baseForegroundColor = UIColor.black
        config.image = UIImage(named: "bath")
        config.imagePadding = 4
        config.baseBackgroundColor = UIColor(rgb: 0xBACBDC)
        config.contentInsets = NSDirectionalEdgeInsets.init(top: 4, leading: 4, bottom: 4, trailing: 4)
        view.configuration = config
        view.imageView?.contentMode = .scaleToFill
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 15)
        return view
    }()
    
    let textViewPlaceHolder = "메모를 남겨보아요 ~"
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.text = textViewPlaceHolder
        textView.backgroundColor = Constants.BaseColor.background
        textView.textColor = .lightGray
        return textView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "물건 버리기"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "paperplane"), style: .plain, target: self, action: #selector(completedBtnClicked))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(closeButtonClicked))
        navigationItem.rightBarButtonItem?.tintColor = UIColor.black
        navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        
        othersBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        clothesBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        shoesBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        deskBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        kitchenBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        babyBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        fridgeBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        bathBtn.addTarget(self, action: #selector(categoryclicked(_:)), for: .touchUpInside)
        
        [bigImageView, othersBtn, clothesBtn, shoesBtn, deskBtn, kitchenBtn, babyBtn, fridgeBtn, bathBtn, textView].forEach {
            view.addSubview($0)
        }
        
        bigImageView.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalTo(UIScreen.main.bounds.width * 0.42)
            make.height.equalTo(186)
        }
       
        othersBtn.snp.makeConstraints { make in
            make.top.equalTo(bigImageView.snp.top)
            make.leading.equalTo(bigImageView.snp.trailing).offset(20)
        }
        
        clothesBtn.snp.makeConstraints { make in
            make.top.equalTo(bigImageView.snp.top)
            make.leading.equalTo(othersBtn.snp.trailing).offset(16)
        }
        
        shoesBtn.snp.makeConstraints { make in
            make.top.equalTo(othersBtn.snp.bottom).offset(20)
            make.leading.equalTo(bigImageView.snp.trailing).offset(20)
        }
        
        deskBtn.snp.makeConstraints { make in
            make.top.equalTo(shoesBtn.snp.top)
            make.leading.equalTo(shoesBtn.snp.trailing).offset(16)
        }
        
        kitchenBtn.snp.makeConstraints { make in
            make.top.equalTo(shoesBtn.snp.bottom).offset(20)
            make.leading.equalTo(bigImageView.snp.trailing).offset(20)
        }
        
        babyBtn.snp.makeConstraints { make in
            make.top.equalTo(kitchenBtn.snp.top)
            make.leading.equalTo(kitchenBtn.snp.trailing).offset(16)
        }
        
        fridgeBtn.snp.makeConstraints { make in
            make.top.equalTo(kitchenBtn.snp.bottom).offset(20)
            make.leading.equalTo(bigImageView.snp.trailing).offset(20)
        }
        
        bathBtn.snp.makeConstraints { make in
            make.top.equalTo(fridgeBtn.snp.top)
            make.leading.equalTo(fridgeBtn.snp.trailing).offset(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(bigImageView.snp.bottom).offset(24)
            make.leading.equalTo(bigImageView.snp.leading)
            make.trailing.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }
        
        categorylist = [othersBtn, clothesBtn, shoesBtn, deskBtn, kitchenBtn, babyBtn, fridgeBtn, bathBtn]
        
        textView.delegate = self
        
        if selectedIndex != -1 {
            categoryclicked(categorylist[selectedIndex])
        }
    }
    
    @objc func categoryclicked(_ sender: UIButton) {
        data.place = (sender.configuration?.title)!
        
        if sender != clickedBtn {
            if clickedBtn != nil {
                clickedBtn.layer.shadowColor = UIColor.white.cgColor
            }
            clickedBtn = sender
        }
        
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.masksToBounds = false
        sender.layer.shadowOffset = CGSize(width: 4, height: 4)
        sender.layer.shadowRadius = 5
        sender.layer.shadowOpacity = 0.3
        
        self.navigationItem.title = "\(data.place) 물건 버리기"
    }
    
    
    @objc func completedBtnClicked() {
        print(isEditing)
        print(isEdited)
        if data.place.isEmpty {
            showAlertMessage(title: "카테고리를 선택해주세요.", button: "확인")
            return
        }
        
        for i in 1...selectImageList.count {
            saveImageToDocument(fileName: "\(data.objectId)_\(i).jpg", image: bigImageView.image!)
        }
        data.imageCount = selectImageList.count
        data.content = isEdited ? textView.text : ""
        data.regDate = Date()
        repository.addItem(data: data)
        
        self.dismiss(animated: true)
    }
    @objc func closeButtonClicked() {
        self.dismiss(animated: true)
    }
    
}
extension MemoViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        isEdited = !textView.text.isEmpty
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
     
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
     
        return changedText.count <= 300
    }
}

