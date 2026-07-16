//
//  CookBoxApp.swift
//  CookBox
//
//  Created by Kishan on 2026-07-12.
//

import SwiftUI
import SwiftData

@available(iOS 26.0, *)
@main
struct CookBoxApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Recipe.self)
        }
    }
}
