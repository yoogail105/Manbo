//
//  Text.swift
//  Manbo
//
//  Created by 성민주민주 on 2022/05/08.
//

import Foundation

enum AlertMenuText: String {
    case ok = "확인"
    case permit = "허용하기"
}

enum AlertText: String {
    case updateMessage = "업데이트 완료!\n업데이트 시 목표 걸음수가 초기화 되었을 수 있으니 확인해 주세요🐾"
    case noLocationTitle = "위치 서비스를 사용할 수 없습니다."
    case noLocationMessage = "지도에서 내 위치를 확인하여 정확한 날씨 정보를 얻기 위해 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요."
    case noHealthKitTitle = "걸음을 가져올 수 없습니다."
    case noHealthKitMessage = "건강 앱에서 내 걸음수를 읽을 수 있도록 '건강 > 걸음 > 데이터 소스 및 접근'에서 만보랑의 읽기 접근을 허용해 주세요."
}

enum OnboardingText: String {
    case welcomeLabel = "처음오셨군요!\n반가워요.\n같이 걸어 볼까요?"
    case nameNoti = "2글자 이상 8글자 이하로 입력해주세요"
}

enum MainText: String {
    
    case iphoneOnly = "만보랑은 아이폰에서 사용이 가능합니다🐾"
    case requestHealthKit = "만보는 여러분의 건강 데이터에 대한 접근을 허용해 주셔야 걸음 수를 알 수 있어요. 아이폰의 '건강 > 걸음 > 데이터 소스 및 접근'에서 만보랑의 읽기 접근을 허용해 주세요!\n허용 후에는 아래의 발자국을 두 번 탭해주세요🐾"
    case defaultMessage = "만보랑 같이 걸어요"
    
    
    
}


enum CalendarText: String {
    case infoStepLable = "👇 선택한 날에 만보와 산책한 기록을 확인할 수 있어요!"
    case infoGoalLabel = "👇 만보의 모습을 통해 그동안의 목표 달성률을 확인할 수 있어요!"
}
