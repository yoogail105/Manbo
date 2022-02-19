# Manbo</br>

🐾 동글동글 만보랑 함께 걸어봐요!</br>
<img width="749" alt="image" src="https://user-images.githubusercontent.com/53874628/149617515-39e98b24-3b83-446d-b99d-1f0977683381.png">
<br/>
🎶 [앱스토어에서 확인하기 v1.0.2](https://apps.apple.com/kr/app/manborang-만보랑-같이-걸어요/id1596845782)

🏞 [기획서 및 진행상황 노션 보러가기](
https://www.notion.so/hmhhsh/c5aa5bab71334879b1eda4a4b3c82583)

## UPDATE

|                                 | 업데이트 사항                                                |
| ------------------------------- | ------------------------------------------------------------ |
| ***[v1.0.3]*** <br />- 22.01.17  | ∙ 지난 달의 걸음 수 평균이 반영되도록 개선했어요.<br />∙ 업데이트 시 목표 걸음수가 초기화되는 버그를 수정했어요.<br /> |
| ***[v1.0.2]*** <br />- 22.01.09 | ∙ 최소 버전을 iOS 15.0 버전으로 올렸어요.<br />   🤧 iOS 15.0 미만을 사용하시는 분들을 위해 열심히 버그를 수정하고 있어요! <br />∙ 더욱 쾌적한 사용 환경을 위해 일부 코드를 개선했어요. |
| ***[v1.0.1]*** <br />- 21.12.22 | ∙ iOS 15.0 미만에서 앱 접속 시 튕기는 버그를 수정했어요.<br />∙ 다크모드에서 일부 텍스트가 보이지 않는 버그를 수정했어요.<br />∙ 만보의 이름 설정 화면에서 배너 등장 시점을 수정했어요. |
| ***[v1.0.0]*** <br />-21.12.20  | ∙ 첫 출시: 만보랑 같이 걸어요 🐾                              |

# Skil, Framework, Library

- **UIKit**
- **MVC** 패턴
- **Storyboard**를 통해 뷰 구현
- **HealthKit**을 활용한 기준 시간에 따른 걸음 정보 업데이트 비동기 처리, 주간∙월간 평균 걸음 수 제공
- **NotificationCenter**, **Observer** 를 활용한 뷰간 데이터 전달 및 실시간 UI 업데이트
- **CustomTabbarController**, **CustomAlertView**
- **OpenWeatherMapAPI**, **CLCoreLocation**, **Alamofire**
- **UICollectionView**, **JPAppleCalendar**, **Realm**을 통해 일/주/월별 걸음 수 표기
- **LocalNotification**, **Firebse CloudMessaging** 를 통해 정해진 시간에 알림 받기
- **Firebase Crashlytics**를 통한 버그 추적 및 지속적인 유지보수



## Issues
#### 1. HealthKit의 read 권한이 확인이 되지 않는 문제<br/>
👉 [move to post](https://velog.io/@yoogail/iOS-HealthKit-read에-대한-접근-권한-확인feat.-확인-불가)<br/>

#### 2.iOS15 미만 버전의 경우 TestFlight에서 시작하자마자 꺼지는 오류
👉 [move to post](https://velog.io/@yoogail/Xcode-13-13.0-시뮬레이터는-되는데-testflight에서는-충돌하는-경우)
<details>
<summary> Summary</summary>
    ✔︎ Xcode 13, 13.1에서 발생하는 오류로, 애플에서 보고된 오류였다.<br/>
    🔗 [애플문서 보러가기](https://developer.apple.com/documentation/xcode-release-notes/xcode-13_2-release-notes)<br/>
    <img width="672" alt="image" src="https://user-images.githubusercontent.com/53874628/147111396-e71311dd-143f-48ef-bad3-ba27eb2a2bac.png"><br/>
    ❗️수정하는 방법<br/>
    <img width="675" alt="image" src="https://user-images.githubusercontent.com/53874628/147111071-ad37bb32-28a4-4759-81e2-90ec15a24913.png"><br/>
</details>

#### 3. Custom TabBar를 이용한 화면 전환 구현하기
👉 [move to post](https://github.com/yoogail105/Manbo/blob/0d17e7637669816d2c3423db9af9243848b4a88e/Documents/CustomTabBarController.md)<br/>

#### 4. 사용자의 설정에 따라 HealthKit의 걸음 데이터 가져오기
👉 [move to post](https://github.com/yoogail105/Manbo/blob/f6bae8a1701103e61ca0254373bd127e4c6deff6/Documents/%EC%82%AC%EC%9A%A9%EC%9E%90%EC%9D%98%20%EC%84%A4%EC%A0%95%EC%97%90%20%EB%94%B0%EB%9D%BC%20HealthKit%20%EA%B1%B8%EC%9D%8C%20%EC%88%98%20%EB%B0%9B%EC%95%84%EC%98%A4%EA%B8%B0.md)

#### 5. 백업 파일이 가진 데이터에 따라 캘린더 업데이트
👉 [move to post](https://github.com/yoogail105/Manbo/blob/07ccbc9f6474883ec408821b0b6aa0686c1a10f5/Documents/%EB%B0%B1%EC%97%85%20%ED%8C%8C%EC%9D%BC%EC%97%90%20%EB%94%B0%EB%9D%BC%20%EC%BA%98%EB%A6%B0%EB%8D%94%20%EC%97%85%EB%8D%B0%EC%9D%B4%ED%8A%B8.md)

#### 6. 월 별 걸음 수 평균 계산하기
👉 [move to post](https://github.com/yoogail105/Manbo/blob/e2961bd5a0421c9d100dc0308154eb292e2a91bf/Documents/%EC%9B%94%EB%B3%84%20%EA%B1%B8%EC%9D%8C%20%EC%88%98%20%ED%8F%89%EA%B7%A0%20%EA%B3%84%EC%82%B0%ED%95%98%EA%B8%B0.md)
        <details>
<summary>Summary</summary>
<div markdown="1">       

```swift

    func calculateMonthlyAverageStepCount(year: Int, month: Int) -> Int {
        
        let monthString = String(format: "%02d", month)
        tasks = localRealm.objects(UserReport.self).sorted(byKeyPath: "date", ascending: false).filter("date CONTAINS [c] '\(year)-\(monthString)'")
        var totalStepCount = 0
  
        tasks.forEach { task in
            print(task.date)
            print(task.stepCount)
            totalStepCount += task.stepCount
        }
        
        let monthlyAverageStepCount = totalStepCount / tasks.count
        return monthlyAverageStepCount
    }

```

</div>
</details>
