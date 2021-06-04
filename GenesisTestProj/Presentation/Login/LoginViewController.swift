//
//  LoginViewController.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import Foundation
import UIKit

class LoginViewController: UIViewController, StoryboardInstantiable {

    var viewModel: LoginViewModel!

    var loginFlowFinished: (() ->())?

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        viewModel.authenticateUser { [weak self]
            isSuccessful, error in

            guard let self = self else { return }

            if isSuccessful {
                self.loginFlowFinished?()
            } else {
                //presenting as an alert for now and from here, in general imo it's better to use some non UI blocking notifications for such messages
                let alert = UIAlertController(title: "Authentication failed", message: "Please, try again", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
