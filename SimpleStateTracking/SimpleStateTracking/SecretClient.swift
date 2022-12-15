//
//  SecretClient.swift
//  SomeMoreTCA
//
//  
//

import Foundation
import ComposableArchitecture

enum PKMN {
  struct `Type`: Decodable {
    var name: String

    enum OuterKeys: String, CodingKey {
      case type
    }

    enum TypeKey: String, CodingKey {
      case name
    }

    init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: OuterKeys.self)
      let typeContainer = try container.nestedContainer(keyedBy: TypeKey.self, forKey: .type)
      self.name = try typeContainer.decode(String.self, forKey: .name)
    }
  }

  struct Fact: Decodable {
    var name: String
    var types: [PKMN.`Type`]

    var typeDescription: String {
      let names = types.map { $0.name }
      return names.joined(separator: " and ")
    }
  }
}

struct SecretClient {
  var fetch: @Sendable (Int) async throws -> String = { number in
    let (data, _) = try await URLSession.shared
      .data(from: URL(string: "https://pokeapi.co/api/v2/pokemon/\(number)")!)
    let pkmn = try JSONDecoder().decode(PKMN.Fact.self, from: data)
    return "\(pkmn.name.uppercased()) is a \(pkmn.typeDescription) type Pokemon."
  }

  static var live: SecretClient = .init()
}
