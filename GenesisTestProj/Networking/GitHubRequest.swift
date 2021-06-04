//
//  GitHubRequest.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/16/21.
//

import Foundation

struct GitHubRequest: Request {

    public let type: RequestType
    public let baseURL: Paths
    public let limit: Int?
    public let contentType: ContentType
    public let sortingFactor: SortingFactor?
    public let questionPhrase: String
    public let page: Int

    public init(baseURL: Paths, type: RequestType, contentType: ContentType, questionPhrase: String, sortingFactor: SortingFactor? = nil, limit: Int? = nil, page: Int) {
        self.baseURL = baseURL
        self.type = type
        self.contentType = contentType
        self.sortingFactor = sortingFactor
        self.limit = limit
        self.questionPhrase = questionPhrase
        self.page = page
    }

    public var completeURL: URL? {
        return URL(string: baseURL.rawValue + contentType.rawValue + "?q=\(questionPhrase)" + "&page=\(page)" + (limit == nil ? "" : "&per_page=\(limit!)") + (sortingFactor == nil ? "" : "&sort=\(sortingFactor!.rawValue)"))
    }
}

enum Paths: String {
    case githubGeneralHost = "https://api.github.com/"
}

enum RequestType: String {
    case get = "GET"
}

enum ContentType: String {
    case repositories = "search/repositories"
}

enum SortingFactor: String {
    case stars = "stars"
    case forks = "forks"
    case wantedIssues = "help-wanted-issues"
    case mostRecent = "updated"
}
