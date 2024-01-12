//
//  UserSearched.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 04/01/24.
//

import SwiftUI
import Combine

class UserSearched: Hashable, Codable, Identifiable {
    var id: UUID
    var name: String
    var login: String

    init(name: String, login: String, id: UUID) {
        self.name = name
        self.login = login
        self.id = id
    }

    static func == (lhs: UserSearched, rhs: UserSearched) -> Bool {
        return lhs.name == rhs.name && lhs.login == rhs.login
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(login)
    }
}
