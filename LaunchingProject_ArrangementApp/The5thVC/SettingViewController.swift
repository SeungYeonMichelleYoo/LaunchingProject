//
//  SettingViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/03.
//
import Foundation
import UIKit
import SnapKit
import MessageUI
import AcknowList

class SettingViewController: BaseViewController {
    let items: [String] = ["문의하기", "오픈소스라이센스", "개인정보 처리방침", "백업 및 복구", "현재 버전"]
    
    var mainView = SettingView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mainView.mainTableView)
        setupTableView()
        
        self.navigationItem.title = "설정"
    }
    
    func setupTableView() {
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.register(SettingTableViewCell.self, forCellReuseIdentifier: "SettingTableViewCell")
        mainView.mainTableView.backgroundView = nil
    }
}

//MARK: - tableview 관련
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingTableViewCell", for: indexPath) as! SettingTableViewCell
        cell.selectionStyle = .none
        cell.titleLabel.text = items[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0: sendMail()
        case 1: gotoOpenSource()
        case 2: let vc = PolicyWebViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        case 3: let newvc = BackupViewController()
            self.navigationController?.pushViewController(newvc, animated: true)
        default:
            return
        }
    }
}

extension SettingViewController: MFMailComposeViewControllerDelegate, UINavigationControllerDelegate{
    
    func sendMail() {
        
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            
            mail.setToRecipients(["lune111200@gmail.com"])
            mail.setSubject("[셀프 정리의 달인] 문의사항")
            let bodyText =
                            """
                            이곳에 내용을 작성해주세요. 피드백은 언제나 환영합니다 ^^
                                                          
                            Device Model : \(self.getDeviceIdentifier())
                            Device OS : \(UIDevice.current.systemVersion)
                            App Version : \(self.getCurrentVersion())
                            """
            mail.setMessageBody(bodyText, isHTML: false)

            self.present(mail, animated: true, completion: nil)
            
        } else {
            showSendMailErrorAlert()
        }
    }
    
    // Device Identifier 찾기
    func getDeviceIdentifier() -> String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }

    // 현재 버전 가져오기
    func getCurrentVersion() -> String {
        guard let dictionary = Bundle.main.infoDictionary,
              let version = dictionary["CFBundleShortVersionString"] as? String else { return "" }
        return version
    }
    
    func showSendMailErrorAlert() {
        let alert = UIAlertController(title: nil, message: "메일을 보낼 수 없습니다. 기본 메일 계정 설정이 되어있는지 확인해주세요.", preferredStyle: UIAlertController.Style.alert)
        let cancel = UIAlertAction(title: "취소", style: .destructive, handler : nil)
        let okAction = UIAlertAction(title: "확인", style: .default) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
              }
        }
        alert.addAction(cancel)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            showAlertMessage(title: "메일을 보낼 수 없습니다. 기본 메일 계정 설정이 되어있는지 확인해주세요.", button: "확인")
        case .saved:
            showAlertMessage(title: "메일을 임시 저장하였습니다.", button: "확인")
        case .sent:
            controller.dismiss(animated: true)
            showAlertMessage(title: "메일 전송에 성공하였습니다.", button: "확인")
        case .failed:
            showAlertMessage(title: "메일을 전송에 실패하였습니다.", button: "확인")
        }
    }
    
    func gotoOpenSource() {
        let vc = AcknowListViewController()
        vc.title = "오픈소스 라이센스"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
