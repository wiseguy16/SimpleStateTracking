//
//  SimpleStateTrackingTests.swift
//  SimpleStateTrackingTests
//
//  Created by Gregory Weiss on 12/15/22.
//

import XCTest
import ComposableArchitecture
@testable import SimpleStateTracking

final class SimpleStateTrackingTests: XCTestCase {

  let numberStore = TestStore(
    initialState: Number.State(number: 0),
    reducer: Number()
  )
  
  func testIncrement() async {
    await numberStore.send(.increment) {
      $0.number = 1
    }
  }
  
  func testDecrement() async {
    await numberStore.send(.decrement) {
      $0.number = -1
    }
  }
  
  func testUpUpUpThenDown() async {
    await numberStore.send(.increment) {
      $0.number = 1
    }
    await numberStore.send(.increment) {
      $0.number = 2
    }
    await numberStore.send(.increment) {
      $0.number = 3
    }
    await numberStore.send(.decrement) {
      $0.number = 2
    }
  }
  
  func testFact() async {
    
    await numberStore.send(.factResponse(.success("3"))) {
      $0.numberFact = "3"
    }
  }
  



}
