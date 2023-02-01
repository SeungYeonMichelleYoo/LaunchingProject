//
//  PolicyWebViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/03.
//

import UIKit
import SnapKit
import WebKit

class PolicyWebViewController: BaseViewController, WKNavigationDelegate {
    
    var mainView = PolicyWebView()
    
    var destinationURL: String = "http://52.79.128.100/privacy.html"
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        openWebPage(url: destinationURL)
        
        self.navigationItem.title = "개인정보 처리방침"
        setNavBackBtn()
        
        mainView.webView.navigationDelegate = self
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        let js = "document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust='250%'"
        webView.evaluateJavaScript(js, completionHandler: nil)
    }
        
    func openWebPage(url: String) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }
        let request = URLRequest(url: url)
        mainView.webView.load(request)
    }
}
