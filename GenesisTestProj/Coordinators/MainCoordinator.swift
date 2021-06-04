//
//  MainCoordinator.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import UIKit

struct MainCoordinator {

    var navigationController: UINavigationController
    var viewControllerFactory: ViewControllerFactory

    init(navigationController: UINavigationController, viewControllerFactory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.viewControllerFactory = viewControllerFactory

        self.navigationController.isNavigationBarHidden = true
    }

    func start() {
        let loginVC = viewControllerFactory.createLoginScreen()
        loginVC.loginFlowFinished = {
            self.startRepositoriesFlow()
        }
        self.navigationController.pushViewController(loginVC, animated: true)
    }

    func startRepositoriesFlow() {
        let repositoriesVC = viewControllerFactory.createRepositoriesScreen()
        self.navigationController.pushViewController(repositoriesVC, animated: true)
    }
}
