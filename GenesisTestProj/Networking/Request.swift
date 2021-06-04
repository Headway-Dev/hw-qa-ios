//
//  Request.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/16/21.
//

import Foundation

protocol Request {
    var completeURL: URL? { get }
    var baseURL: Paths { get }
    var type: RequestType { get }
}
