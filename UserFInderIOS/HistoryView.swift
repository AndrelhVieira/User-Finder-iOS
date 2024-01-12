//
//  HistoryView.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 04/01/24.
//

import SwiftUI
import CoreData

extension Color {
    init(hex_history: String) {
        let hex = hex_history.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (r, g, b) = ((int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (r, g, b) = (int >> 16, int >> 8 & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255.0,
            green: Double(g) / 255.0,
            blue:  Double(b) / 255.0,
            opacity: 1
        )
    }
}


struct HistoryView: View {
    @ObservedObject var storageManager = MyStorageManager()
    @State private var refreshID = UUID()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("History")
                        .foregroundColor(.white)
                        .font(.title)
                        .fontWeight(.bold)
                    ForEach(storageManager.objectList) { user in
                        HistoryCardView(user: user, onRemove: { removedUser in
                            removeSearch(removedUser)
                            refreshID = UUID() // Trigger a view update
                        })
                    }
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
            }
            .background(Color("#3c6997"))
        }
        .onAppear(perform: loadHistory)
    }

    func loadHistory() {
            let retrievedList = MyStorageManager().getObjectList()

            if retrievedList.isEmpty {
                print("STORAGE VAZIO", retrievedList)
            }
        }

        func removeSearch(_ removedUser: UserSearched) {
            // Remove the selected search from the history
            MyStorageManager().saveObjectList(MyStorageManager().objectList.filter { $0 != removedUser })

            // Trigger a view update
            refreshID = UUID()
        }
}

struct HistoryCardView: View {
    var user: UserSearched
    var onRemove: (UserSearched) -> Void
    @State private var showingConfirmation = false

    var body: some View {
        VStack {
            Text(user.name)
                .foregroundColor(.white)
                .font(.title3)
                .fontWeight(.bold)
                .padding()
            Text(user.login)
                .foregroundColor(.white)
                .font(.callout)
                .fontWeight(.bold)
                .padding()

            Button(action: {
                            showingConfirmation = true
                        }) {
                            Text("Remove Search")
                                .font(.title3)
                                .padding()
                                .background(Color("#3c6997"))
                                .foregroundColor(.white)
                                .bold()
                        }
                        .alert(isPresented: $showingConfirmation) {
                            Alert(
                                title: Text("Confirm Removal"),
                                message: Text("Are you sure you want to remove this search?"),
                                primaryButton: .cancel(Text("Cancel")),
                                secondaryButton: .destructive(Text("Remove"), action: {
                                    removeSearch()
                                })
                            )
                        }
                        .padding()
        }
        .background(Color("#094074"))
    }

    func removeSearch() {
            // Remover a pesquisa selecionada do histórico
            var updatedList = MyStorageManager().getObjectList()
            if let index = updatedList.firstIndex(where: { $0.id == user.id }) {
                updatedList.remove(at: index)
                MyStorageManager().saveObjectList(updatedList)
            }
            onRemove(user)
        }
}


#Preview {
    HistoryView()
}
