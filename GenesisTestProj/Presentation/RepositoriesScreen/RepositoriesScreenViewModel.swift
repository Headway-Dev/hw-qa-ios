//
//  RepositoriesScreenViewModel.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import RxSwift

class RepositoriesScreenViewModel {

    // MARK: - Vars

    private var networkServices: NetworkService
    private var persistenceService: PersistenceService

    private var visitedRepositories = [Repository]()
    private var currentPage = 1

    var repositories: BehaviorSubject<[Repository]> = BehaviorSubject(value: [])

    // MARK: - Initialization

    init(networkServices: NetworkService, persistenceService: PersistenceService) {
        self.networkServices = networkServices
        self.persistenceService = persistenceService
    }

    // MARK: - Main funcs

    func requestData(for query: String, isPagination: Bool = false) {
        if !query.isEmpty {
            _ = networkServices.getRepositories(questionPhrase: query.replacingOccurrences(of: " ", with: "%20"), page: currentPage, sortingFactor: .stars).subscribe({
                repositoryResponse in
                if let repositoryResponse = repositoryResponse.element {
                    self.currentPage += 2
                    if isPagination {
                        do {
                            self.visitedRepositories.forEach({
                                visitedRepository in
                                repositoryResponse.filter({$0.id == visitedRepository.id}).first?.isVisited = true
                            })
                            self.repositories.onNext(try self.repositories.value() + repositoryResponse)
                            return
                        } catch {

                        }
                    }
                    self.visitedRepositories.forEach({
                        visitedRepository in
                        repositoryResponse.filter({$0.id == visitedRepository.id}).first?.isVisited = true
                    })
                    self.repositories.onNext(repositoryResponse)
                }
            })
        } else {
            repositories.onNext([])
        }
    }

    func makeVisitedWith(id: Int) {
        do {
            if let repository = try self.repositories.value().filter({$0.id == id}).first {
                repository.isVisited = true
                updateVisitedRepositories(with: repository)
                self.repositories.onNext(try self.repositories.value())
            }
        } catch {
        }
    }

    func showVisitedRepositories() {
        currentPage = 0
        let completion: ([Repository]?, CustomError?) -> () = {
            repository, error in

            if let repository = repository {
                self.repositories.onNext(repository)
            } else {
                self.repositories.onNext([])
            }
        }
        readVisitedRepositories(completion)
    }

    func readVisitedRepositories(_ completion: @escaping ([Repository]?, CustomError?) -> ()) {
        persistenceService.readFrom(fileName: Constants.visitedRepositoriesDefaultFileName, completion: completion)
    }

    func updateVisitedRepositories(with repository: Repository) {
        if visitedRepositories.isEmpty {
            visitedRepositories.append(repository)

            readVisitedRepositories({ [weak self]
                repositories, error in

                //separate guard in order to use self in else statement in the next guard
                guard let self = self else { return }

                guard var repositories = repositories else {
                    self.persistenceService.save(data: self.visitedRepositories, withName: Constants.visitedRepositoriesDefaultFileName, completion: nil)
                    return
                }
                if repositories.count >= Constants.visitedRepositoriesLimit {
                    repositories.removeLast()
                    repositories.append(repository)
                } else {
                    repositories.append(repository)
                }
                self.visitedRepositories = repositories
                self.persistenceService.save(data: repositories, withName: Constants.visitedRepositoriesDefaultFileName, completion: nil)
            })
        } else {
            if visitedRepositories.count >= Constants.visitedRepositoriesLimit {
                visitedRepositories.removeLast()
                visitedRepositories.append(repository)
            } else {
                visitedRepositories.append(repository)
            }
            persistenceService.save(data: visitedRepositories, withName: Constants.visitedRepositoriesDefaultFileName, completion: nil)
        }
    }
}
