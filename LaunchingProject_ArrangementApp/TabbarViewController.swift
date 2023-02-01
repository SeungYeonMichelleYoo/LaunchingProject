//
//  TabbarViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/09/08.
//
import UIKit

class TabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    //defaultIndex의 초기값을 0으로 설정해놓고, 아이템이 선택되면 그 아이템의 인덱스가 defaultIndex로 변경되게 함
    var defaultIndex = 0 {
        didSet {
            self.selectedIndex = defaultIndex
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = defaultIndex
        self.delegate = self
        configure()
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if selectedIndex == 1 {
            UserDefaults.standard.set(false, forKey: "isSecondVCLoaded")
        }
        guard let viewController = self.viewControllers?[self.selectedIndex] as? UINavigationController else { return }
        viewController.popToRootViewController(animated: true)
    }
    
    func configure() {
        
        let firstViewController = TrashViewController()
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        firstNavigationController.tabBarItem.title = "버린 물건들"
        firstNavigationController.tabBarItem.image = UIImage(named: "tab1_broom")
        firstNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 3, right: 0)
        firstNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        firstNavigationController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 6) // 왜 안되는걸까?

        let secondViewController = YoutubeViewController()
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        secondNavigationController.tabBarItem.title = "정리 꿀팁"
        secondNavigationController.tabBarItem.image = UIImage(named: "tab2_tips")
        secondNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 3, right: 0)
        secondNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
        
        let thirdViewController = BeforeAfterViewController()
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        thirdNavigationController.tabBarItem.title = "비포 & 애프터"
        thirdNavigationController.tabBarItem.image = UIImage(named: "tab3_beforeafter")
        thirdNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 3, right: 0)
        thirdNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]

        
        let fourthViewController = ShopViewController()
        let fourthNavigationController = UINavigationController(rootViewController: fourthViewController)
        fourthNavigationController.tabBarItem.title = "정리 아이템"
        fourthNavigationController.tabBarItem.image = UIImage(named: "tab4_shop")
        fourthNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 3, right: 0)
        fourthNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]

        
        let fifthViewController = SettingViewController()
        let fifthNavigationController = UINavigationController(rootViewController: fifthViewController)
        fifthNavigationController.tabBarItem.title = "설정"
        fifthNavigationController.tabBarItem.image = UIImage(named: "tab5_settings")
        fifthNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: 3, right: 0)
        fifthNavigationController.navigationBar.titleTextAttributes = [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 20)]
 
        
        let viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController, fourthNavigationController, fifthNavigationController]
        self.setViewControllers(viewControllers, animated: false)
        
        
        ///TabBar 설정
        let tabBar: UITabBar = self.tabBar
        //        tabBar.isHidden = false
        //        tabBar.layer.borderWidth = 0
        //        tabBar.clipsToBounds = true
        tabBar.isTranslucent = false
        
        let appearance = UITabBarAppearance()
        // set tabbar opacity
        appearance.configureWithOpaqueBackground()
        
        // remove tabbar border line
        appearance.shadowColor = UIColor.clear
        
        appearance.backgroundColor = .white
        
        tabBar.standardAppearance = appearance
        
        if #available(iOS 15.0, *) {
            // set tabbar opacity
            tabBar.scrollEdgeAppearance = tabBar.standardAppearance
        }
        
        //선택되었을 때 타이틀 컬러
        tabBar.tintColor = .black
        //선택안된거 타이틀 컬러
        tabBar.unselectedItemTintColor = .lightGray
        
        //네비게이션 뷰컨으로 푸쉬했을 때 밑에 바가 사라지지 않도록
        self.hidesBottomBarWhenPushed = false
    }
}
