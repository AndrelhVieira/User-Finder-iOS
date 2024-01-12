//
//  MyStorageManager.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 04/01/24.
//

import SwiftUI
import Combine
import Foundation

class MyStorageManager: ObservableObject {
    @Published var objectList: [UserSearched] = []

    init() {
        self.objectList = getObjectList()
    }

    func getObjectList() -> [UserSearched] {
        if let data = UserDefaults.standard.data(forKey: "UserSearchedList"),
           let decoded = try? JSONDecoder().decode([UserSearched].self, from: data) {
            return decoded
        }
        return []
    }

    func saveObjectList(_ newList: [UserSearched]) {
        if let encoded = try? JSONEncoder().encode(newList) {
            UserDefaults.standard.set(encoded, forKey: "UserSearchedList")
            self.objectList = newList
        }
    }
}
