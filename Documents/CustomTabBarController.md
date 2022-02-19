## ✍️ Custom TabBar를 이용한 화면 전환 구현하기

### 1. 탭바 화면으로 이용할 스토리보드를 만들어준 후, 탭바를 만든다.

<img width="150" alt="image" src="https://user-images.githubusercontent.com/53874628/154792467-12d2cfe9-39e3-40ee-bbfc-480a2eb6e815.png">

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


**❗️알아야할 것 **

```swift
// 기존의 뷰 지우기

// childVC삭제될 거라고 알려줌
previousVC.willMove(toParent: nil)
previousVC.view.removeFromSuperview()
// parentVC와의 관계 끊음
previousVC.removeFromParent()
```

이 코드를 적지 않고 빌드를 한 후에 여러 화면을 클릭하면.. 아래와 같이 기존에 누른 화면이 유지된다.

<img width="600" alt="image" src="https://user-images.githubusercontent.com/53874628/154792610-17b90efa-0b25-4e66-b1ec-28a4ba119563.png">

→ 그래서 childVC가 parentVC에 추가 되기 전이나 후, 제거되기 전이나 후를 알려주는 메서드를 적어준다.

**`willMove(toParent:)`**:Called just before the view controller is added or removed from a container view controller.

<img width="284" alt="image" src="https://user-images.githubusercontent.com/53874628/154792636-b640a066-919f-4e36-9615-39a939c65eae.png">

→ 위의 코드 적어주면 여러 화면을 누른 후에 계층을 확인해도, 아래처럼 지금 선택된 것만 나온다.

<img width="368" alt="image" src="https://user-images.githubusercontent.com/53874628/154792640-b0fa26e8-8654-41c2-9519-f219e5f47bac.png">

- 🔖 참고
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

위의 함수에서 인덱스로 사용되기 때문에, 순서를 유념해서 지정해야 한다.<br/>
<img width="576" alt="image" src="https://user-images.githubusercontent.com/53874628/154792700-a9750f5d-c78f-40bd-a8d2-e22cc3057d67.png">


🔖 참고

[iOS Swift\] Floating Custom Tab Bar 만들기](https://dvpzeekke.tistory.com/69)

[CustomTabBar Controller 제작기](https://milyo-codingstories.tistory.com/11)

[swift - viewController에 viewController 추가하기 #addChild()](https://jinsangjin.tistory.com/119)

[How To Create a Custom TabBar in Swift](https://betterprogramming.pub/how-to-create-a-custom-tabbar-in-swift-d44b3db3ac0e)

[Array of UIButtons in Swift 4](https://stackoverflow.com/questions/50068413/array-of-uibuttons-in-swift-4)
