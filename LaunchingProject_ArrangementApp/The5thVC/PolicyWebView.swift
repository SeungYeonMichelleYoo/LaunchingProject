//
//  PolicyWebView.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/03.
//
import UIKit
import SnapKit
import WebKit

class PolicyWebView: BaseView {
    
    //MARK: - next button
    lazy var webView: WKWebView = {
        let view = WKWebView()
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureUI() {
        [webView].forEach {
            self.addSubview($0)
        }
    }
    override func setConstraints() {
        
        webView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(self.safeAreaLayoutGuide).inset(20)
        }
    }
}

