//
//  UserService.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/18/21.
//

import Foundation

class UserService {
    private lazy var user = User()

    func saveToken(withValue value: String) {
        user.token = value
    }
}
