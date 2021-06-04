//
//  RepositoryInfoCell.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/16/21.
//

import UIKit

class RepositoryInfoCell: UITableViewCell {
    
    @IBOutlet private weak var repositoryNameLabel: UILabel!
    @IBOutlet private weak var ownerNameLabel: UILabel!
    @IBOutlet private weak var isVisitedIconImageView: UIImageView!

    func setupView(with repository: Repository) {
        repositoryNameLabel.text = repository.name
        ownerNameLabel.text = repository.fullName
        isVisitedIconImageView.isHidden = !repository.isVisited
    }

}
