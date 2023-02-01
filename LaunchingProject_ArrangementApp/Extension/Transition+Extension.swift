//
//  Transition+Extension.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/09.
//

import UIKit

extension UIViewController {
    
    enum TransitionStyle {
        case push
    }
    
    func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .push) {
        switch transitionStyle {
        case .push:
            self.navigationController?.pushViewController(viewController, animated: true)
        
        }
    }
}
