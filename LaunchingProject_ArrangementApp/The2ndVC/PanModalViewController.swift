//
//  PanModalViewController.swift
//  LaunchingProject_ArrangementApp
//
//  Created by SeungYeon Yoo on 2022/10/02.
//

import Foundation
import UIKit
import SnapKit
import PanModal

class PanModalViewController: BaseViewController {
    var youtubeData: YoutubeModel!
    var mainView = PanModalView()
    
    override func loadView() {
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.mainTableView.delegate = self
        mainView.mainTableView.dataSource = self
        mainView.mainTableView.register(PanModalViewCell.self, forCellReuseIdentifier: "PanModalViewCell")
        
    }
}

extension PanModalViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = mainView.mainTableView.dequeueReusableCell(withIdentifier: "PanModalViewCell", for: indexPath) as! PanModalViewCell
        let contentString = """
        * 출처: '\(youtubeData.youtubeURL.replacingOccurrences(of: "embed/", with: "watch?v="))'
        * 본 영상은 <셀프 정리의 달인>이 아닌 제 3자가 자체적으로 제작한 것으로, <셀프 정리의 달인> 입장과 다를 수 있습니다.
        해당 내용을 신뢰하여 발생하는 손해 등에 대해서 <셀프 정리의 달인>에게 책임이 없음을 알려드립니다.
        또한 사용하시는 제품, 상황 등에 따라 본 영상의 내용과는 다른 결과가 나타날 수 있음에 유의해 주시기 바랍니다.
        """
        let attrString = NSMutableAttributedString(string: contentString)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        cell.contentLabel.attributedText = attrString
             

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}


extension PanModalViewController: PanModalPresentable {
    
    var panScrollable: UIScrollView? {
        return mainView.mainTableView
    }
    
    var shortFormHeight: PanModalHeight {
        return .contentHeight(400)
    }
    
    var longFormHeight: PanModalHeight {
        return .maxHeightWithTopInset(200)
    }
    
    var anchorModalToLongForm: Bool {
        return true
    }
}
