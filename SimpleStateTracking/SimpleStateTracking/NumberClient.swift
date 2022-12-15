//
//  NumberClient.swift
//  SomeMoreTCA
//
//

import Foundation
import ComposableArchitecture

struct NumberClient {
  var fetch: @Sendable (Int) async throws -> String
}

extension NumberClient {
  static let live: NumberClient = .init(fetch: { number in
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "http://numbersapi.com/\(number)/trivia")!)
    return String(decoding: data, as: UTF8.self)
  })

  static let test: NumberClient = .init { number in
    return "\(number) is a very cool number. You have good taste."
  }

  static let preview: NumberClient = .init { number in
    try await Task.sleep(for: .seconds(2))
    return "Did you know \(number) \(number % 2 == 0 ? "is" : "is not") divisible by 2?"
  }
}

extension NumberClient: DependencyKey {
  static let liveValue = NumberClient.live
  static let testValue = NumberClient.test
  static let previewValue = NumberClient.preview
}

extension DependencyValues {
  var numberClient: NumberClient {
    get { self[NumberClient.self] }
    set { self[NumberClient.self] = newValue }
  }
}

extension Task where Success == Never, Failure == Never {
  
  static func sleep(for duration: Duration) async throws {
    try await Task.sleep(nanoseconds: UInt64(duration.components.seconds * 1_000_000_000))
  }
}

