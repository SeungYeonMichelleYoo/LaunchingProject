//
//  UIViewController+Extension.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/11/20.
//
import UIKit

extension UIViewController {
    func setNavBackBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(navBtnClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
    }
    
    @objc func navBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}
