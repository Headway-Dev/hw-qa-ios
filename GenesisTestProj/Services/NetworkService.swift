//
//  NetworkService.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/15/21.
//

import RxSwift
import RxCocoa

class NetworkService {

    // MARK: - Vars & Lets

    private let apiManager: APIManager
    private let bag = DisposeBag()
    private lazy var jsonDecoder = JSONDecoder()

    // MARK: - Initialization

    init(apiManager: APIManager) {
        self.apiManager = apiManager
    }

    // MARK: - Funcs

    func getRepositories(questionPhrase: String, page: Int, sortingFactor: SortingFactor? = nil) -> Observable<[Repository]> {
        let firstRequestPart = GitHubRequest(baseURL: .githubGeneralHost, type: .get, contentType: .repositories, questionPhrase: questionPhrase, sortingFactor: sortingFactor, limit: Constants.postLimit, page: page)
        let secondRequestPart = GitHubRequest(baseURL: .githubGeneralHost, type: .get, contentType: .repositories, questionPhrase: questionPhrase, sortingFactor: sortingFactor, limit: Constants.postLimit, page: page + 1)

        return Observable<[Repository]>.create({ (observer) -> Disposable in

            _ = Observable.zip(self.apiManager.make(request: firstRequestPart), self.apiManager.make(request: secondRequestPart)) { ($0, $1) }
              .subscribe(onNext: { firstRequestData, secondRequestData in

                if let firstRequestData = firstRequestData, let secondRequestData = secondRequestData {

                    self.jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase

                    if let firstPart = try? self.jsonDecoder.decode(RepositoryResponse.self, from: firstRequestData), let secondPart = try? self.jsonDecoder.decode(RepositoryResponse.self, from: secondRequestData) {

                        let result = firstPart.items + secondPart.items

                        observer.onNext(result)
                        observer.onCompleted()
                    } else {
                        observer.onError(NSError(domain: "Network error occured", code: 404, userInfo: nil) )
                    }
                }
              })
              return Disposables.create()
          })
    }
}
