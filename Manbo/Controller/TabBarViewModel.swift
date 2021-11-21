//
//  TabBarViewModel.swift
//  Manbo
//
//  Created by minjoohehe on 2021/11/19.
//

import Foundation

struct TabBarVM: Equatable {
  let tabs: [String]
  let selectedTab: Int

  func shouldReload(from oldModel: Self?) -> Bool {
    return self.tabs != oldModel?.tabs || self.selectedTab != oldModel?.selectedTab
  }
    
}
