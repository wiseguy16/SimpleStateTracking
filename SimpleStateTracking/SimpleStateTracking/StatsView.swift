//
//  StatsView.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/14/22.
//

import SwiftUI
import ComposableArchitecture


struct StatsView: View {
  let store: StoreOf<UserStats>
    var body: some View {
      WithViewStore(self.store) { viewStore in
        VStack(spacing: 20) {
          Text("Preferred Number: \(viewStore.currentFavoriteNumber)")
          Text("Preferred NickName: \(viewStore.preferredName)")
          Divider()
          Text("Times Incremented: \(viewStore.timesIncremented)")
          Text("Times Decremented: \(viewStore.timesDecremented)")
          Button("Reset Stats", action: {
            viewStore.send(.resetStats)
          })
          Button("Reset Everything") {
            viewStore.send(.resetAll)
          }.foregroundColor(.red)

          Button("Set my favorite number to 42") {
//            viewStore.send(.number(.increment))
            viewStore.send(.setMeaningOfLife)
          }
        }
        .navigationTitle("User Stats")
      }
    }
}

struct StatsView_Previews: PreviewProvider {
    static var previews: some View {
      StatsView(store: .init(
        initialState: UserStats.State(),
        reducer: UserStats())
      )
    }
}
