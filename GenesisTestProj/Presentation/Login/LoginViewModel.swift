//
//  LoginViewModel.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import Foundation

class LoginViewModel {

    let authService: AuthService
    let userService: UserService

    init(authService: AuthService, userService: UserService) {
        self.authService = authService
        self.userService = userService
    }

    func authenticateUser(_ completion: @escaping (Bool, CustomError?) -> ()) {

        let authCompletion: (String?, CustomError?) -> () = { [weak self]
            token, error in

            guard let self = self else { return }

            if let token = token {
                self.userService.saveToken(withValue: token)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }

        authService.authorizeUser(authCompletion)
    }
}
