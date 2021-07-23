//
//  ThemeSettings.swift
//  WaToDo
//
//  Created by Ronald on 23/7/21.
//

import SwiftUI

class ThemeSettings : ObservableObject {
    @Published var themeSettings: Int = UserDefaults.standard.integer(forKey: "Theme") {
        didSet {
            UserDefaults.standard.set(self.themeSettings, forKey: "Theme")
        }
    }
}
