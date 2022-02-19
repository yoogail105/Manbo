# 사용자의 설정에 따라 HealthKit 걸음 수 받아오기

예를들어, HealthKit의 인터벌을 60분으로 할 경우, 시간별로 받아온다.

<img width="290" alt="image" src="https://user-images.githubusercontent.com/53874628/154793043-f247b126-11f7-4ade-85c6-3a07e434aa05.png">

사용자가 설정한 시간의 걸음 데이터를 받아오기 위해서는 startDate와 endDate의 지정이 필요하다.
시간을 지정하고 더할 수 있는 Calendar의 .date(byAdding: , value: , to:)를 이용하기로 했다.
그리고 걸음이 생성될 때마다 값을 더하면 되지 않을까?

```swift
                                  
let dateFormatter = DateFormatter()
let calendar = Calendar.current
var date = Date()

dateFormatter.timeZone = calendar.timeZone
dateFormatter.locale = calendar.locale

//오늘, 새벽 2시부터 내일 새벽 2시까지
let year = calendar.component(.year, from: date)
let month = calendar.component(.month, from: date)
let day = calendar.component(.day, from: date)

var dateComponents = DateComponents(year: year, month: month, day: day, hour: 02)
let startDate = calendar.date(from: dateComponents)
let endDate = calendar.date(byAdding: .hour, value: 24, to: startDate!)
```
<img width="616" alt="image" src="https://user-images.githubusercontent.com/53874628/154793056-501dc824-de65-47f5-b290-c604efc1666b.png">
위와 같이, 시작시간을 새벽 2시로 설정할 경우, 00시부터 02시까지의 데이터는 받아와지지 않는 것을 확인할 수 있었다.

유저의 설정에 따라서 달라지도록 하기 위해서, UserDefaults에서 값을 가져와 주었다.
```swift
//유저데이터
let resetTimeString = UserDefaults.standard.resetTime
        dateFormatter.dateFormat = "HH:mm"
        let resetTime = dateFormatter.date(from: resetTimeString!)
        let hour = calendar.component(.hour, from: resetTime!)
        let minute = calendar.component(.minute, from: resetTime!)

// 지금날짜
let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)

//위의 정보로 시작 날짜 만들기
let dateComponents = DateComponents(year: year, month: month, day: day, hour: hour, minute: minute)
```

                                  
                                  
                                  
