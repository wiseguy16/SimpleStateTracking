//
//  NumberStore.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/6/22.
//

import Foundation
import SwiftUI
import ComposableArchitecture

struct Number: ReducerProtocol {
  @Dependency(\.numberClient) var numberClient
  struct State: Equatable {
    var number: Int
    var numberFact: String?
    var factLoading: Bool = false
  }

  enum Action: Equatable {
    case increment
    case decrement
    case requestFact
    case factResponse(TaskResult<String>)
  }

  func reduce(into state: inout State, action: Action) -> Effect<Action, Never> {
    switch action {
    case .increment:
      state.number += 1

      return .none
    case .decrement:
      state.number -= 1
      return .none

    case .requestFact:
      state.numberFact = nil
      state.factLoading = true
      return .task { [number = state.number] in
        await .factResponse(TaskResult { try await self.numberClient.fetch(number) })
      }
    case let .factResponse(.success(response)):
      state.factLoading = false
      state.numberFact = response
      return .none
    case let .factResponse(.failure(error)):
      state.factLoading = false
      state.numberFact = "Something went wrong: \(error.localizedDescription)"
      return .none
    }
  }
}
