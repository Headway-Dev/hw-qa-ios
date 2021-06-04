//
//  DependencyContainer.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import UIKit
import RxSwift

class DependencyContainer {

    private let navigationController: UINavigationController

    //MARK: - Coordinators
    private lazy var mainCoordinator = MainCoordinator(navigationController: navigationController, viewControllerFactory: self)

    //MARK: - Coordinators
    private lazy var apiManager = APIManager()

    //MARK: - Services
    private lazy var authService = AuthService()
    private lazy var networkService = NetworkService(apiManager: apiManager)
    private lazy var persistenceService = PersistenceService()
    private lazy var userService = UserService()

    //MARK: - Reactive-related dependencies
    private lazy var disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    //MARK: - Flow functions
    func start() {
        mainCoordinator.start()
    }
}

extension DependencyContainer: ViewControllerFactory {
    func createRepositoriesScreen() -> RepositoriesScreenViewController {
        let vc = RepositoriesScreenViewController.instantiate()

        let viewModel = RepositoriesScreenViewModel(networkServices: networkService, persistenceService: persistenceService)
        vc.viewModel = viewModel

        return vc
    }

    func createLoginScreen() -> LoginViewController {
        let vc = LoginViewController.instantiate()
        let viewModel = LoginViewModel(authService: authService, userService: userService)
        vc.viewModel = viewModel
        return vc
    }
}
