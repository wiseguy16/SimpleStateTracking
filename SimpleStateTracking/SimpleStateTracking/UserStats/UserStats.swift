//
//  UserStats.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/14/22.
//

import Foundation
import ComposableArchitecture

struct UserStats: ReducerProtocol {
  struct State: Equatable {
    var numberState: Number.State = .init(number: 0)
    var preferredNameState: PreferredName.State = .init()
    var timesIncremented: Int = 0
    var timesDecremented: Int = 0
    var timesNicknameChanged: Int = 0

    var currentFavoriteNumber: Int {
      self.numberState.number
    }

    var preferredName: String {
      self.preferredNameState.nickname
    }
  }

  enum Action {
    case resetStats
    case resetAll
    case setMeaningOfLife
    case number(Number.Action)
    case name(PreferredName.Action)
  }

  var body: some ReducerProtocol<State, Action> {
    CombineReducers {
      Scope(state: \.numberState, action: /UserStats.Action.number) {
        Number()
      }

      Scope(state: \.preferredNameState, action: /UserStats.Action.name) {
        PreferredName()
      }

      Reduce { state, action in
        switch action {
        case .number(.decrement):
          // We can run some action any time a number is decremented!
          state.timesDecremented += 1
          return .none
        case .number(.increment):
          // Or when it goes up!
          state.timesIncremented += 1
          return .none
        case .name(.setNickname(let value)):
          state.timesNicknameChanged += 1
          debugPrint("The parent knows you just changed your nickname to \(value)")
          return .none
        case .setMeaningOfLife:
          state.numberState.number = 42
          return .none
        case .resetStats:
          state.timesIncremented = 0
          state.timesDecremented = 0
          state.timesNicknameChanged = 0
          return .none
        case .resetAll:
          state = .init()
          return .none
        default:
          return .none
        }
      }
    }._printChanges()
  }
}

