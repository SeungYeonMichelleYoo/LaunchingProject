//
//  DetailWebViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/12.
//

import UIKit
import SnapKit
import WebKit

//MARK: - 상품 상세 정보 페이지
class DetailWebViewController: BaseViewController {
    
    var productData: ProductModel!
    
    var destinationURL: String = ""
    
    //MARK: - webView
    private let webView = WKWebView()
    
    //MARK: - indicator
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.color = .systemGreen
        indicator.isHidden = true
        return indicator
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        
        [webView, indicator].forEach {
            self.view.addSubview($0)
        }
        
        webView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        print(destinationURL)
        
        openWebPage(url: destinationURL)
        
        //MARK: - navigation item / title
        self.navigationItem.title = "\(productData.productTitle)"
        setNavBackBtn()
    }
        
    //MARK: - WebKit
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        webView.load(request)
    }
  
}
//MARK: - indicator
extension DetailWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) { //웹 페이지 정보 수신하기 시작할 때
        indicator.isHidden = false
        indicator.startAnimating()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) { //웹 페이지가 보여지는 것이 다 끝나면
        indicator.stopAnimating()
        indicator.isHidden = true
    }
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) { //웹 페이지 불러오다가 실패했을 때
        indicator.stopAnimating()
        indicator.isHidden = true
    }
}
