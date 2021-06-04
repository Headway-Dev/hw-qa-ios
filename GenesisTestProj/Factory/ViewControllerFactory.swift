//
//  ViewControllerFactoryProtocol.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/17/21.
//

import Foundation

protocol ViewControllerFactory {
    func createRepositoriesScreen() -> RepositoriesScreenViewController
    func createLoginScreen() -> LoginViewController
}
