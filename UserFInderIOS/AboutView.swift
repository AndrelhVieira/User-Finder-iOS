//
//  AboutView.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 04/01/24.
//

import SwiftUI
import CoreData

extension Color {
    init(hex_about: String) {
        let hex = hex_about.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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



struct AboutView: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("About")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                    Text("The main purpose of this application is to streamline access to the account of friends, employees or even yours, easily providing the path to the main Github projects for that user. You can also see what your latest searches were through your search history.")
                        .font(.callout)
                        .foregroundColor(.white)
                    Text("How it works")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                    Text("1. On the search page you will find a field to enter the username (Attention: only the username) and a button to do the search.")
                        .font(.callout)
                        .foregroundColor(.white)
                    Text("2. As soon as you click the button, a record of your search is visible in your search history and you can repeat it.")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical, 5)
                    Text("3. Your search will return the main information and repositories about that user, thus facilitating, the access to the projects of that account.")
                        .font(.callout)
                        .foregroundColor(.white)
                        .padding(.vertical, 10)
                    Image("complete_logo_user_finder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 100)
                    Text("Developed by Andre Luiz Vieira")
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)

            }
            .background(Color("#3c6997"))
        }
    }
}

#Preview {
    AboutView()
}
