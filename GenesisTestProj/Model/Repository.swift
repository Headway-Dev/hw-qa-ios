//
//  Repository.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/15/21.
//

import Foundation

class Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let isPrivate: Bool
    let htmlUrl: String?
    let description: String?

    var isVisited = false

    enum CodingKeys: String, CodingKey {
        case id, name, description, fullName, htmlUrl
        case isPrivate = "private"
    }
}

