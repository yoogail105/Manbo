## ✍️ Custom TabBar를 이용한 화면 전환 구현하기

### 1. 탭바 화면으로 이용할 스토리보드를 만들어준 후, 탭바를 만든다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/aadd5e67-6118-4766-8c3b-5e2c511b11b8/Untitled.png)

### 2. TabViewController 연결

```swift
class TabViewController: UIViewController {

    @IBOutlet weak var tabBarBackgroundView: UIView!

		//현재 선택한 버튼: 이곳에서 저장한 것이 어플의 초기 화면이 된다.
    var selectedIndex: Int = 0
    var previousIndex: Int = 0
    
		// VC들을 담을 배열
    var vcList = [UIViewController]()
    
	// (탭바이템으로 사용될) 버튼들을 담을 배열
    @IBOutlet var buttons:[UIButton]!
    @IBOutlet var tabView:UIView!
    
    let mainVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: ViewController.identifier)
    let cameraVC = UIStoryboard(name: "Camera", bundle: nil).instantiateViewController(withIdentifier: CameraViewController.identifier)
    let calendarVC = UIStoryboard(name: "Calendar", bundle: nil).instantiateViewController(withIdentifier: CalendarViewController.identifier)
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tabBarBackgroundView.cornerRounded(cornerRadius: tabBarBackgroundView.frame.size.height / 2)
        
        // VC배열에 넣기
        vcList = [mainVC, cameraVC, calendarVC]
	    
				// 첫 뷰 불러오기
        buttons[selectedIndex].isSelected = true
        tabChanged(sender: buttons[selectedIndex])
    }
}

// MARK: - Actions
extension TabViewController {
    @IBAction func tabChanged(sender:UIButton) {
        previousIndex = selectedIndex
        selectedIndex = sender.tag
        
        buttons[previousIndex].isSelected = false
        let previousVC = vcList[previousIndex]
        
				// 아래를 적지 않으면, 기존에 호출한 뷰들이 계속 유지된다
				// 기존에 선택되어있던 VC와의 관계성을 끊는다.
        previousVC.willMove(toParent: nil)
        previousVC.view.removeFromSuperview()
        previousVC.removeFromParent()
        
				// 새로 선택된 버튼과 연결하기
        sender.isSelected = true

        *//....?*
        let vc = vcList[selectedIndex]
        vc.view.frame = UIApplication.shared.windows[0].frame
        vc.didMove(toParent: self)
        self.addChild(vc)
        self.view.addSubview(vc.view)
        
        self.view.bringSubviewToFront(tabView)
    }
}
```

**❗️알아야할 것**

```swift
// 기존의 뷰 지우기

// childVC삭제될 거라고 알려줌
previousVC.willMove(toParent: nil)
previousVC.view.removeFromSuperview()
// parentVC와의 관계 끊음
previousVC.removeFromParent()
```

이 코드를 적지 않고 빌드를 한 후에 여러 화면을 클릭하면.. 아래와 같이 기존에 누른 화면이 유지된다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/cc15b18e-497e-4a61-a51d-d183fe9f6485/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/028f4707-b13e-445c-998e-53d745e1a9dd/Untitled.png)

→ 그래서 childVC가 parentVC에 추가 되기 전이나 후, 제거되기 전이나 후를 알려주는 메서드를 적어준다.

**`willMove(toParent:)` :**Called just before the view controller is added or removed from a container view controller.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/a8f69516-5606-486d-a2d1-318be0b62adc/Untitled.png)

→ 위의 코드 적어주면 여러 화면을 누른 후에 계층을 확인해도, 아래처럼 지금 선택된 것만 나온다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/0caf5eb0-7b2b-448d-8a2e-234c0b05f2e0/Untitled.png)

- 참고

  [swift - viewController에 viewController 추가하기 #addChild()](https://jinsangjin.tistory.com/119)

### 3. 버튼과 액션 연결

```
@IBOutlet var buttons:[UIButton]!
@IBAction func tabChanged(sender:UIButton)
```

을 내가 탭바아이템으로 만든 버튼들에 연결해 주어야 한다.

이 때

```swift
// override func viewDidLoad()...
buttons[selectedIndex].isSelected = true
tabChanged(sender: buttons[selectedIndex])

// @IBAction func tabChanged(sender:UIButton)...
let vc = viewControllers[selectedIndex]
```

위의 함수에서 인덱스로 사용되기 때문에, 순서를 유념해서 지정해야 한다.

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/1c89ee4e-2367-4d77-b3b8-f41203969f85/Untitled.png)

![Untitled](https://s3-us-west-2.amazonaws.com/secure.notion-static.com/2bb9038a-a58f-4acb-b79f-aa72bf8ceab9/Untitled.png)

🔖 참고

[iOS Swift\] Floating Custom Tab Bar 만들기](https://dvpzeekke.tistory.com/69)

[CustomTabBar Controller 제작기](https://milyo-codingstories.tistory.com/11)

[swift - viewController에 viewController 추가하기 #addChild()](https://jinsangjin.tistory.com/119)

[How To Create a Custom TabBar in Swift](https://betterprogramming.pub/how-to-create-a-custom-tabbar-in-swift-d44b3db3ac0e)

[Array of UIButtons in Swift 4](https://stackoverflow.com/questions/50068413/array-of-uibuttons-in-swift-4)
