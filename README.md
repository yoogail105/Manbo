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


## Features

<details>
<summary>1. 월별 걸음 수 평균 조회</summary>
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

## Issues
1. HealthKit의 read 권한이 확인이 되지 않는 문제<br/>
👉 [HealthKit authorization status: read](https://velog.io/@yoogail/iOS-HealthKit-read에-대한-접근-권한-확인feat.-확인-불가)<br/>
<br/>
<details>
<summary>2.iOS15 미만 버전의 경우 TestFlight에서 시작하자마자 꺼지는 오류</summary>
    ✔︎ Xcode 13, 13.1에서 발생하는 오류로, 애플에서 보고된 오류였다.<br/>
    🔗 [애플문서 보러가기](https://developer.apple.com/documentation/xcode-release-notes/xcode-13_2-release-notes)<br/>
    <img width="672" alt="image" src="https://user-images.githubusercontent.com/53874628/147111396-e71311dd-143f-48ef-bad3-ba27eb2a2bac.png"><br/>
    ❗️수정하는 방법<br/>
    <img width="675" alt="image" src="https://user-images.githubusercontent.com/53874628/147111071-ad37bb32-28a4-4759-81e2-90ec15a24913.png"><br/>
</details>
<br/>
