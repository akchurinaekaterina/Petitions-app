//
//  Petitions.swift
//  Petitions app
//
//  Created by Ekaterina Akchurina on 25.09.2020.
//

import Foundation

struct Petitions: Codable {
    var results: [Petition]
}

struct Petition: Codable {
    var title: String
    var body: String
    var signatureCount: Int
}
