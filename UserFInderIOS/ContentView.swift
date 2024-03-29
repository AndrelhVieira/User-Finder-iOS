//
//  ContentView.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 28/12/23.
//

import SwiftUI
import CoreData

extension Color {
    init(_ hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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


struct ContentView: View {
    var body: some View {
        NavigationView {
        ZStack {
            Color("#094074").edgesIgnoringSafeArea(.all)

            VStack {
                Image("cover")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250, height: 250)
                Image("complete_logo_user_finder")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 200, height: 100)
                Text("Welcome to User Finder")
                    .font(.title)
                    .bold()
                    .foregroundColor(.white)
                Text("Here you will find the main information about any github account")
                    .font(.callout)
                    .padding()
                    .foregroundColor(.white)
                NavigationLink(destination: SearchView()) {
                    Text("SEARCH AN ACCOUNT")
                        .font(.title3)
                        .padding()
                        .background(Color("#3c6997"))
                        .foregroundColor(.white)
                        .bold()
                }
            }
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
