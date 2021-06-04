//
//  APIManager.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/15/21.
//

import Foundation
import RxSwift
import RxCocoa

class APIManager {
    private let urlSession = URLSession.shared
    private var jsonDecoder = JSONDecoder()

    public init() {}
    
    func make(request: Request) -> Observable<Data?> {
        return Observable<Data?>.create { observer  in
            
            if let url = request.completeURL {
                self.urlSession.dataTask(with: url, completionHandler: {
                    data, response, error in
                    
                    observer.onNext(data)
                    
                    if error != nil {
                        observer.onError(error!)
                    }
                    
                    observer.onCompleted()
                }).resume()
            }
            
            let disposable = Disposables.create()
            return disposable
        }
    }
}

enum RequestError {
    case networkRequestFailed
    case unknownError
}
