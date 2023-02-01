# 👩‍💻 개인 출시 앱 <셀프 정리의 달인>  


<img width="1045" alt="스크린샷 2023-01-31 오전 12 38 45" src="https://user-images.githubusercontent.com/87454813/215522473-8d8b3327-4360-4ea8-9432-cb6635744740.png">

  
  
## 소개

#### 집 정리에 대한 꿀팁을 제공하며, 버리기 아쉬운 물건을 버리며 깨끗해지는 집이 되게 도와주는 앱  

정리는 버리는 것에서부터 시작해요.
아끼는 물건을 버리는 것을 아쉬워하는 사람들이 사진을 찍어 일기에 저장해서 추억을 꺼내볼 수 있어요. 일기를 쓰면서 아쉬운 마음을 털어버리고 물건을 버리게 도와주는 앱.  
  
깨끗한 우리집을 만들기 위해 유명한 정리 전문가들의 꿀팁을 참고해볼 수도 있어요.  
  
정리 전의 우리집 vs. 정리 후의 우리집 사진을 비교하며, 깨끗하게 변신한 우리집을 보며 뿌듯함을 느껴보아요.  
  
  
<a href="https://itunes.apple.com/app/id1645006071"> <img src="https://user-images.githubusercontent.com/87454813/215519178-39229e51-b5cb-4dd9-b0d1-7a9e89c03974.png" width="100" height="100"/> 앱 다운로드 바로가기</a>
  
  
## 특징
- 서버개발자, UI/UX 디자이너와 협업
- AWS 자체 서버 사용  
- 협업 툴: Notion, Figma  
  
  
## 개발 기간 / 개발 환경
2022.9.8 - 2022.10.1 (약 3주)

<img width="95" src="https://img.shields.io/badge/Xcode-14.1.0-blue"> <img width="77" src="https://img.shields.io/badge/iOS-15.0+-silver">  
  
## 사용한 기술 및 오픈소스 라이브러리   
<b>UI</b>   
Snapkit, UIKit, Autolayout, IQKeyboardManager, PanModal, UITableView, UICollectionView, UITabGestureRecognizer, Animation  

<b>디자인패턴</b>   
MVC, Repository, Singleton
   
<b>네트워크</b>   
Alamofire, SwiftyJSON   
   
<b>DB</b>   
Realm   
    
<b>기타</b>   
WebKit, MessageUI, YPImagePicker, Kingfisher, AcknowList, Zip, Firebase analytics, Firebase Crashlytics   


## 화면별 핵심 기능  
### 사진 일기 저장  
<img width="677" alt="스크린샷 2023-01-28 오후 3 19 45" src="https://user-images.githubusercontent.com/87454813/215521703-0c6b6ce4-8e1c-4979-a359-d4f9ae117ce4.png">  
- YPImagePicker 사용하여 사용자가 사진에 필터 효과 적용 가능                                          
- 이미지 50%로 압축하여 데이터로 저장함으로써 용량 감소 효과, 이미지 리사이징   

### 정리 꿀팁 유튜브 모음 / 정리 관련 용품 쇼핑  
<img width="617" alt="스크린샷 2023-01-28 오후 3 21 13" src="https://user-images.githubusercontent.com/87454813/215521726-71062666-4c97-4ed4-9d3a-1239aea6fda5.png">  
  
  
<img width="610" alt="스크린샷 2023-01-28 오후 3 22 13" src="https://user-images.githubusercontent.com/87454813/215521783-0e6cfbd1-1201-4553-b9c8-be1d6ea7a7bb.png">  
  
AWS 자체 서버에 ‘정리 꿀팁’에 대해 직접 엄선한 Youtube 동영상과 정리 관련 상품들을 저장
  
  
## 서버 관리 예시  
  
<img width="953" alt="스크린샷 2023-01-28 오후 3 17 40" src="https://user-images.githubusercontent.com/87454813/215521855-2ce4b155-c44b-49df-a62c-c9baccf958db.png">



## 💪 Trouble Shooting

✅ **자주 사용하고 반복되는 UI 특성 코드(Color, 테두리 둥글게 등) - Enum으로 상수화하여 하나의 파일로 관리**

```swift
enum Constants {

    enum Design {
        static let cornerRadius: CGFloat = 8
        static let borderWidth: CGFloat = 1
    }
		enum BaseColor {
        static let background = UIColor(rgb: 0xF5F5F4)
        static let border = UIColor(rgb: 0x2B4240)
        static let textcolor = UIColor(rgb: 0x9AA4AB)
        static let placeholder = UIColor.lightGray
        static let pointcolor = UIColor(rgb: 0x678FAB)
    }
}
```

```swift
extension UIViewController {
    func setNavBackBtn() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(navBtnClicked))
        self.navigationItem.leftBarButtonItem?.tintColor = Constants.BaseColor.textcolor
    }
    
    @objc func navBtnClicked() {
        self.navigationController?.popViewController(animated: true)
    }
}
```

✅ **Facebook 피드에서 이미지 클릭하면 확대해서 띄워지는 효과 구현 (Animation Zoom In / Zoom Out)**

```swift
TabbarViewController().tabBar.isHidden = true
        
        let centeredX = (view.frame.width - zoomImageView.frame.width) / 2
        zoomImageView.transform = CGAffineTransform(translationX: centeredX, y: 300)
        
        //MARK: - zoom in
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            let y = UIScreen.main.bounds.height * 0.25
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: 400)
            self.blackBackgroundView.alpha = 0.8
            self.navBarCoverView.alpha = 0.5
            self.tabBarController?.tabBar.isHidden = true
            self.navigationItem.rightBarButtonItem = nil
            self.navigationController?.navigationBar.barTintColor = .darkGray
            self.navigationController?.navigationBar.alpha = 0.99
        })
    }
    
    @objc func zoomOut() {
        let startingFrame = statusImageView.frame
        UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackBackgroundView.alpha = 0
        }) { (didComplete) -> Void in
            self.zoomImageView.removeFromSuperview()
            self.blackBackgroundView.removeFromSuperview()
            self.closeButton.removeFromSuperview()
            self.statusImageView?.alpha = 1
            self.closeButton.removeFromSuperview()
            self.dateLabel.removeFromSuperview()
            self.deleteButton.removeFromSuperview()
            self.navBarCoverView.alpha = 0
            self.navigationController?.navigationBar.barTintColor = nil
            self.navigationController?.navigationBar.alpha = 1
            self.tabBarController?.tabBar.isHidden = false
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(self.plusbuttonClicked))
            self.navigationItem.rightBarButtonItem?.tintColor = Constants.BaseColor.pointcolor
        }
    }
```  
  
  
✅ **네트워크 없는 경우 Indicator 띄우기 / 네트워크 설정으로 이동 유도**  
  
  <img src="https://user-images.githubusercontent.com/87454813/215517803-42f9738f-aa47-4cf3-be77-a082398dbaad.jpeg" width="200" height="400"/>
    
  
```swift
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
```  
  
  
✅ **이미지 50%로 압축하여 데이터로 저장함으로써 용량 감소 효과, 이미지 리사이징**

```swift
//MARK: - The1stVC - ThingDiary 이미지 - 도큐먼트 저장 코드
    func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } //용량 줄이기
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save error", error)
        }
    }
  
    func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } //Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) //세부 경로. 이미지를 저장할 위치)
        //fileURL이 있는지 물어보는 코드
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path) // 이 위치에 있는걸 이미지로 담기
        } else {
            return UIImage(named: "camera")
        }
    }
```  
  
  
## 💡 회고

 **🐣 성장한 부분** 

- **Apple AppStore에 앱을 등록하는 처음부터 끝까지의 과정을 경험, 1번의 reject 없이 심사 통과**
    
    카메라 권한 설정 및 필요없는 이미지가 Assets 파일에 남아있지 않게 하는 등 자잘하게 신경 쓸 요소가 많았다.
    
- **개발 후반부 디자이너 합류로 인한** **잦은 기획 변경에 대한 대응 / 화면 UI 설계에 대한 여러가지 시도**
    
    기획자, 디자이너 없이 처음부터 내가 설계했는데, 디자이너가 합류한 뒤 기획이 많이 바뀌었다. 그에 따라 개발 내용도 많이 바뀌어서 UIMenu, SideMenu 등의 여러 가지 시도를 해볼 수 있었다.
    

 **🙈 아쉬웠던 점** 

- **MVC → MVVM 패턴으로 바꾸는 것이 좋아보인다.**
    
    같은 기능을 가진 화면을 묶어서 반복되는 코드를 View Model에 배치한다면 좀 더 깔끔하고 효율적인 코드가 될 것 같다.
    
    1, 3번째 탭의 기능(사진 일기 작성) / 2, 4번째 탭의 기능(서버통신 및 유튜브 및 상품 정보 불러오기) 이 비슷하기 때문에, 반복되는 코드를 묶어서 짰으면 효율적이었을 것 같다.  
- **앱 업데이트 시 재미 요소를 넣으면 좋을 것 같다.**  
   사용자가 정리를 하고 일기를 작성할 수록 뿌듯함을 느낄 수 있게 레벨 업 기능 추가 고려.
    
    
### 📌 Version History  
1.0.3 Nov 21, 2022  
- UI 업데이트, 안정성 개선  

1.0.2 Oct 18, 2022  
- UI 업데이트  
- 백업,복원 기능 추가  

1.0.1 Oct 6, 2022  
- UI 업데이트  
- 영상 출처 및 고지사항 게시  
- 버그 해결  
- 상품 가격 추가  
- 설정 탭 추가  
- 카테고리 추가  

1.0 Sep 30, 2022  
- 출시
    
