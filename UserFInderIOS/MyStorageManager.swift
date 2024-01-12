//
//  MyStorageManager.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 04/01/24.
//

import Foundation

struct UserSearch: Codable {
    let fullName: String
    let username: String
}

class MyStorageManager {
    static let shared = MyStorageManager()
    private let userDefaults = UserDefaults.standard
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private let storageKey = "UserSearchList"

    func saveObjectList(_ list: [UserSearch]) {
        if let encodedData = try? encoder.encode(list) {
            userDefaults.set(encodedData, forKey: storageKey)
        }
    }

    func getObjectList() -> [UserSearch] {
        if let savedData = userDefaults.object(forKey: storageKey) as? Data {
            if let decodedList = try? decoder.decode([UserSearch].self, from: savedData) {
                return decodedList
            }
        }
        return []
    }
}
