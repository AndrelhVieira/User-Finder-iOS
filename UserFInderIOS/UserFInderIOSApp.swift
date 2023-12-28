//
//  UserFInderIOSApp.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 28/12/23.
//

import SwiftUI

@main
struct UserFInderIOSApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
