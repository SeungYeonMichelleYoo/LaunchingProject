//
//  YoutubeWebViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/10.
//
import UIKit
import SnapKit
import WebKit
import PanModal

class YoutubeWebViewController: BaseViewController, UIScrollViewDelegate {
    
    var photoList: [String] = ["broom", "fridge", "shoes", "baby", "closet", "bath", "kitchen", "desk", "others"]
    
    var youtubeData: YoutubeModel!
    var destinationURL = ""
    
    //MARK: -Webkit
    lazy var videoPlayer: UIView = {
        let view = UIView()
        return view
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.color = Constants.BaseColor.textcolor
        indicator.isHidden = true
        
        return indicator
    }()
    
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var placeImg: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleToFill
        view.image = UIImage(named: "kitchen")
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor.black
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var copyrightBtn: UIButton = {
        let view = UIButton()
        view.setTitle("출처 및 고지사항", for: .normal)
        view.titleLabel?.font =  UIFont(name: "Times New Roman", size: 14)
        view.setTitleColor(.lightGray, for: .normal)
        view.setUnderline()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        [videoPlayer, indicator, scrollView].forEach {
            view.addSubview($0)
        }
        
        scrollView.addSubview(contentView)
        
        [placeImg, titleLabel, contentLabel, copyrightBtn].forEach {
            scrollView.addSubview($0)
        }
        
        self.navigationItem.title = "\(youtubeData.youtubeSection) 정리 꿀팁"
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
        
        print(destinationURL)
        
        videoPlayer.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(220)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(videoPlayer.snp.bottom)
        }
        
        contentView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(videoPlayer.snp.bottom)
            make.centerX.equalToSuperview()
            //            make.width.equalToSuperview().multipliedBy(0.85)
        }
        
        placeImg.snp.makeConstraints { make in
            make.top.equalTo(scrollView).inset(40)
            make.width.equalTo(32)
            make.height.equalTo(32)
            make.leading.equalTo(scrollView).inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(placeImg)
            make.width.equalToSuperview().multipliedBy(150)
            make.leading.equalTo(placeImg.snp.trailing).offset(4)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(40)
            make.width.equalToSuperview().multipliedBy(0.85)
            make.leading.equalTo(scrollView).inset(24)
        }
        
        copyrightBtn.snp.makeConstraints { make in
            make.top.equalTo(contentLabel.snp.bottom).offset(70)
            make.trailing.equalTo(contentLabel.snp.trailing)
            make.bottom.equalTo(scrollView).inset(50)
        }
        
        titleLabel.text = youtubeData.youtubeTitle
        contentLabel.text = youtubeData.youtubeContent
        
        addCharacterSpacinginUILabel()
        
        scrollView.delegate = self
        copyrightBtn.addTarget(self, action: #selector(copyrightBtnClicked), for: .touchUpInside)
    }
    
    @objc func copyrightBtnClicked() {
        let vc = PanModalViewController()
        vc.youtubeData = self.youtubeData
        presentPanModal(vc)
    }
    
    //MARK: - UILabel 안 행간 간격(자간)
    func addCharacterSpacinginUILabel() {
        let attrString = NSMutableAttributedString(string: contentLabel.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        contentLabel.attributedText = attrString
    }
    
    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - WebKit
    override func viewWillAppear(_ animated: Bool) {
        if !UserDefaults.standard.bool(forKey: "isYoutubeLoaded") {
            let webConf = WKWebViewConfiguration()
            webConf.allowsInlineMediaPlayback = true
            DispatchQueue.main.async {
                let webPlayer = WKWebView(frame: self.videoPlayer.bounds, configuration: webConf)
                self.videoPlayer.addSubview(webPlayer)
                guard let videoURL = URL(string: "\(self.youtubeData.youtubeURL)?playsinline=1") else { return } //works with vimeo as well
                let request = URLRequest(url: videoURL)
                webPlayer.navigationDelegate = self
                webPlayer.load(request)
            }
            UserDefaults.standard.set(true, forKey: "isYoutubeLoaded")
        }
    }
}


//MARK: - indicator
extension YoutubeWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { //웹 페이지 정보 수신하기 시작할 때
        indicator.isHidden = false
        indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { //웹 페이지가 보여지는 것이 다 끝나면
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
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
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { //웹 페이지 불러오다가 실패했을 때
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}

extension UIButton {
    func setUnderline() {
        guard let title = title(for: .normal) else { return }
        let attributedString = NSMutableAttributedString(string: title)
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(attributedString, for: .normal)
    }
}
