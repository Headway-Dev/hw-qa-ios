//
//  PersistenceService.swift
//  GenesisTestProj
//
//  Created by Maksym Sabadyshyn on 2/16/21.
//

import Foundation

class PersistenceService {
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    func save<T: Encodable>(data: T, withName fileName: String, completion: ((T?, CustomError?) -> ())?) {
        do {
            let fileContentData = try encoder.encode(data)
            let fileContent = String(data: fileContentData, encoding: String.Encoding.utf8)

            if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first, let fileContent = fileContent {

                let fileURL = dir.appendingPathComponent(fileName)

                do {
                    try fileContent.write(to: fileURL, atomically: false, encoding: .utf16)
                    completion?(data, nil)
                }
                catch {
                    completion?(nil, .savingFailed)
                }

            }
        } catch {
            completion?(nil, .savingFailed)
        }
    }

    func readFrom<T: Decodable>(fileName: String, completion: (T?, CustomError?)->()) {

        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {

            let fileURL = dir.appendingPathComponent(fileName)

            do {
                let fileStringContent = try Data(contentsOf: fileURL)
                let fileObject = try decoder.decode(T.self, from: fileStringContent)
                completion(fileObject, nil)
            }
            catch {
                completion(nil, .readingFailed)
            }
        } else {
            completion(nil, .invalidDirectory)
        }
    }
}

public enum CustomError: Error {
    case savingFailed
    case readingFailed
    case invalidDirectory
    case networkRequestFailed
    case authFailed
}
