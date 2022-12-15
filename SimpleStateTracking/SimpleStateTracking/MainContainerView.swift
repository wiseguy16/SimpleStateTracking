//
//  MainContainerView.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/13/22.
//

import SwiftUI
import ComposableArchitecture

struct MainContainerView: View {
  let store: StoreOf<UserStats>
  @State private var numberScreenIsActive = false
  @State private var nickNameScreenIsActive = false
  @State private var statsScreenIsActive = false
  
    var body: some View {
      NavigationView {
        VStack {
          NavigationLink(
            destination: NumberView(
              store: self.store.scope(state: \.numberState, action: UserStats.Action.number)
            ),
            isActive: $numberScreenIsActive) { EmptyView() }
          
          NavigationLink(
            destination: NickNameView(store: self.store.scope(state: \.preferredNameState, action: UserStats.Action.name)),
            isActive: $nickNameScreenIsActive) { EmptyView() }
          
          NavigationLink(
            destination: StatsView(store: self.store),
            isActive: $statsScreenIsActive) { EmptyView() }
          
          Button(action: { numberScreenIsActive.toggle() },
                 label: {
            Text("Go to Favorite Number")
          })
          
          Spacer().frame(height: 20)
          
          Button(action: { nickNameScreenIsActive.toggle() },
                 label: {
            Text("Go to Preferred NickName")
          })
          
          Spacer().frame(height: 20)
          
          Button(action: { statsScreenIsActive.toggle() },
                 label: {
            Text("Go to User Stats")
          })
        }
        .navigationTitle("Main Container View")
      }
    }
}

struct MainContainerView_Previews: PreviewProvider {
    static var previews: some View {
      MainContainerView(
        store: .init(
          initialState: .init(),
          reducer: UserStats()
        )
      )
    }
}
