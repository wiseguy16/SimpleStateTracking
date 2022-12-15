//
//  CounterView.swift
//  SomeMoreTCA
//
//  Created by GWE48A on 10/6/22.
//

import SwiftUI
import ComposableArchitecture

struct NumberView: View {
  let store: StoreOf<Number>
  
    var body: some View {
      WithViewStore(store) { viewStore in
        VStack {
          Text("Select your Favorite Number")
          HStack {
            Button(
              action: { viewStore.send(.decrement) },
             label: {
              Text("-").font(.largeTitle)
            }).padding()
            
            Text("<- Select ->")
            
            Button(
              action: { viewStore.send(.increment) },
             label: {
              Text("+").font(.largeTitle)
            }).padding()
          }
          
          Text("\(viewStore.number)").font(.largeTitle)
          
          Button(
            action: { viewStore.send(.requestFact) },
            label: {
              Text("Get Number fact")
            }).buttonStyle(.borderedProminent)
          
          Text("\(viewStore.numberFact ?? "")").padding()
        }
        .navigationTitle("Favorite Number")
      }
    }
  
}

struct NumberView_Previews: PreviewProvider {
    static var previews: some View {
      NumberView(
        store: Store(
          initialState: Number.State(number: 0),
          reducer: Number()
        )
      )
    }
}
