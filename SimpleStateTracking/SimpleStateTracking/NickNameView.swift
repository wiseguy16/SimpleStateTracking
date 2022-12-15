//
//  NickNameView.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/14/22.
//

import SwiftUI
import ComposableArchitecture

struct DotLoaderBehavior: ReducerProtocol {
  struct State: Equatable {
    var scaleID: Int = 1
  }

  enum Action {
    case setColor(Color)
    case scaleChanged(Int)
    case start
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .start:
      return .run { send in
        while true {
          for var i in 1...3 {
            await send(.scaleChanged(i), animation: .easeIn)
            try await Task.sleep(for: .seconds(0.5))
            if i == 3 {
              i = 1
            }
          }
        }
      }
    case .scaleChanged(let id):
      state.scaleID = id
      return .none
    default:
      return .none
    }
  }
}

struct DotLoader: View {
  let store: StoreOf<DotLoaderBehavior>
  var body: some View {
    WithViewStore(self.store) { viewStore in
      ZStack {
        RoundedRectangle(cornerRadius: 4)
          .stroke(lineWidth: 2)
        HStack {
          Circle()
            .fill(Color.red)
            .scaleEffect(viewStore.scaleID == 1 ? 1.5 : 1)
          Circle()
            .fill(Color.yellow)
            .scaleEffect(viewStore.scaleID == 2 ? 1.5 : 1)
          Circle()
            .fill(Color.green)
            .scaleEffect(viewStore.scaleID == 3 ? 1.5 : 1)
        }.padding()
      }.frame(width: 100, height: 100)
        .task {
          await viewStore.send(.start).finish()
        }
    }
  }
}

struct PreferredName: ReducerProtocol {
  struct State: Equatable {
    var nickname: String = ""
    var avatar: Image?
    var avatarLoading: Bool = false
  }

  enum Action {
    case setNickname(String)
    case avatarFound(Image)
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .setNickname(let name):
      state.nickname = name
      state.avatarLoading = true
      return .run { send in
        try await Task.sleep(for: .seconds(3))
        let data = try await URLSession.shared.data(from:  URL(string: "https://avatars.dicebear.com/api/adventurer/\(name.addingPercentEncoding(withAllowedCharacters: .alphanumerics) ?? name.replacingOccurrences(of: " ", with: "")).png")!).0

        await send(.avatarFound(Image(uiImage: UIImage(data: data)!)))
      }
    case .avatarFound(let image):
      state.avatarLoading = false
      state.avatar = image
      return .none
    }
  }
}

struct NickNameView: View {
  let store: StoreOf<PreferredName>
  @State var nickname: String = ""
//  struct ViewState: Equatable {
//    var nickname: String
//  }
  
    var body: some View {
      WithViewStore(self.store) { viewStore in
        VStack {
          ZStack {

            RoundedRectangle(cornerRadius: 4)
              .stroke(lineWidth: 2)
              .frame(width: 100, height: 100)
            if viewStore.avatarLoading {
              DotLoader(store: .init(initialState: .init(), reducer: DotLoaderBehavior()))
            } else if let image = viewStore.avatar {
              image
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .frame(width: 100, height: 100)
            }

          }
          // viewStore.binding(\.$nickname)
          TextField("Enter your NickName", text: $nickname)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()

          Button(action: {
            viewStore.send(.setNickname(nickname))
          },
                 label: {
            Text("Set NickName")
          })
        }
        .navigationTitle("Preferred NickName")
      }
    }
}

struct NickNameView_Previews: PreviewProvider {
    static var previews: some View {
      NickNameView(
        store: .init(
          initialState: .init(),
          reducer: PreferredName()
        )
      )
    }
}
