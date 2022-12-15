//
//  SimpleStateTrackingApp.swift
//  SimpleStateTracking
//
//  Created by Gregory Weiss on 12/15/22.
//

import SwiftUI
import ComposableArchitecture

@main
struct SimpleStateTrackingApp: App {
    var body: some Scene {
        WindowGroup {
          MainContainerView(
            store: .init(
              initialState: .init(),
              reducer: UserStats()
            )
          )
        }
    }
}
