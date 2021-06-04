//
//  AuthService.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import OAuthSwift

class AuthService {

    let oauthSwift = OAuth2Swift(
        consumerKey: Constants.githubClientCode,
        consumerSecret: Constants.githubClientSecret,
        authorizeUrl:   "https://github.com/login/oauth/authorize",
        accessTokenUrl: "https://github.com/login/oauth/access_token",
        responseType:   "code"
    )

    func authorizeUser(_ completion: @escaping (String?, CustomError?) -> ()) {
        _ = oauthSwift.authorize(
            withCallbackURL: "Saba.GenesisTestProj://auth",
            scope: "", state:"github") { handler in
            do {
                if let token = try handler.get().response?.dataString() {
                    completion(token, nil)
                } else {
                    completion(nil, .authFailed)
                }
            } catch {
                completion(nil, .authFailed)
            }
        }
    }
}
