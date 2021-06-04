//
//  RepositoriesScreenViewController.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import UIKit
import RxSwift
import RxCocoa
import SafariServices

class RepositoriesScreenViewController: UIViewController, StoryboardInstantiable {

    // MARK: - IBOutlets

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var repositoriesTableView: UITableView!
    @IBOutlet private weak var savedButton: UIButton!

    // MARK: - Vars and lets

    private let startLoadingOffset: CGFloat = 5.0

    private var disposeBag = DisposeBag()
    private var isInSavedMode = false

    var viewModel: RepositoriesScreenViewModel!

    // MARK: - Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupRx()
    }

    // MARK: - IBActions

    @IBAction private func savedRepositoriesOpened(_ sender: UIButton) {

        if isInSavedMode {
            savedButton.setTitle("Saved", for: .normal)
            viewModel.requestData(for: searchBar.text ?? "")
            searchBar.isHidden = false
        } else {
            savedButton.setTitle("Current", for: .normal)
            viewModel.showVisitedRepositories()
            searchBar.isHidden = true

        }

        isInSavedMode.toggle()
    }

    // MARK: - Main funcs

    private func setupRx() {
        viewModel.repositories
            .bind(to: repositoriesTableView.rx.items(cellIdentifier: "RepositoryInfoCell", cellType: RepositoryInfoCell.self)) {  (row, repository, cell) in
                cell.setupView(with: repository)
            }
            .disposed(by: disposeBag)
        
        repositoriesTableView.rx.modelSelected(Repository.self)
            .map { (id: $0.id, url: $0.htmlUrl ?? "") }
            .observe(on: SerialDispatchQueueScheduler(qos: .background))
            .subscribe(onNext: { [weak self] model in
                guard let url = URL(string: model.url), let self = self else {
                    return
                }
                
                if !self.isInSavedMode {
                    self.viewModel.makeVisitedWith(id: model.id)
                }
                self.present(SFSafariViewController(url: url), animated: true)
            })
            .disposed(by: disposeBag)
        
        searchBar.rx.text
            .throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self]
                query in
                guard let self = self else { return }
                
                self.viewModel.requestData(for: query ?? "")
            })
            .disposed(by: disposeBag)
        
        repositoriesTableView.rx.contentOffset
            .throttle(DispatchTimeInterval.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] offset in
                
                guard let self = self else { return }
                
                if self.isNearTheBottomEdge(offset, self.repositoriesTableView) {
                    if let queryText = self.searchBar.text, !queryText.isEmpty, !self.isInSavedMode {
                        self.viewModel.requestData(for: queryText, isPagination: true)
                    }
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupView() {
        repositoriesTableView.delegate = self
        repositoriesTableView.register(UINib(nibName: "RepositoryInfoCell", bundle: nil), forCellReuseIdentifier: String(describing: RepositoryInfoCell.self))
    }


    private func isNearTheBottomEdge(_ contentOffset: CGPoint, _ tableView: UITableView) -> Bool {
        return contentOffset.y +
            tableView.frame.size.height +
            startLoadingOffset > tableView.contentSize.height
    }

}

extension RepositoriesScreenViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
