//
//  AppleWatchAppSampleApp.swift
//  AppleWatchAppSample WatchKit Extension
//
//  Created by tomohiko on 2021/12/19.
//

import SwiftUI

@main
struct AppleWatchAppSampleApp: App {
    @SceneBuilder var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
        }

        WKNotificationScene(controller: NotificationController.self, category: "myCategory")
    }
}
