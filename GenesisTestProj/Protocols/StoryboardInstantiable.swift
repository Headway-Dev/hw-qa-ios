//
//  StoryboardInstantiable.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/14/21.
//

import Foundation
import UIKit

protocol StoryboardInstantiable {
    static var defaultFileName: String { get }
    static func instantiate(_ bundle: Bundle?) -> Self
}

extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiate(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let id = String(describing: self)
        let storyboard = UIStoryboard(name: fileName, bundle: Bundle.main)
        guard let vc = storyboard.instantiateViewController(identifier: id) as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with id: \(id)")
        }
        return vc
    }
}
