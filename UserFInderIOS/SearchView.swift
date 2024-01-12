//
//  SearchView.swift
//  UserFInderIOS
//
//  Created by André Luiz Hiller Vieira on 28/12/23.
//


import SwiftUI
import CoreData
import SDWebImageSwiftUI
import Combine

extension Color {
    init(hex_search: String) {
        let hex = hex_search.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
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

struct SearchView: View {
    @State private var usernameToSearch: String = ""
      @State private var userData: UserData?
        
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    NavigationLink(destination: HistoryView()) {
                        Text("HISTORY")
                            .font(.title3)
                            .padding()
                            .background(Color("#094074"))
                            .foregroundColor(.white)
                            .bold()
                    }
                    NavigationLink(destination: AboutView()) {
                        Text("ABOUT")
                            .font(.title3)
                            .padding()
                            .background(Color("#094074"))
                            .foregroundColor(.white)
                            .bold()
                    }
                    Text("Search")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                    TextField("Enter GitHub username", text: $usernameToSearch)
                        .padding()
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(Color("#094074"))
                    Button("RETRIEVE USERNAME") {
                        searchUser()
                    }
                    .font(.headline)
                    .padding()
                    .background(Color("#094074"))
                    .foregroundColor(.white)
                    .bold()
                    if let userData = userData {
                        UserCard(userData: userData)
                    }
                    
                    Image("complete_logo_user_finder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 100)
                    Text("Developed by Andre Luiz Vieira")
                        .foregroundColor(.white)
                }
                .padding()
            }
            .background(Color("#3c6997"))
        }
    }

    func searchUser() {
        let userApiUrl = "https://api.github.com/users/\(usernameToSearch)"
        let reposApiUrl = "https://api.github.com/users/\(usernameToSearch)/repos"

        fetchUser(url: userApiUrl) { user in
            fetchRepos(url: reposApiUrl) { repos in
                DispatchQueue.main.async {
                    self.userData = UserData(name: user.name ?? "",
                                             login: user.login,
                                             followers: "\(user.followers)",
                                             following: "\(user.following)",
                                             publicRepos: "\(user.public_repos)",
                                             avatarURL: user.avatar_url,
                                             repositories: repos)
                    
                    saveSearchOnStorage(name: user.name ?? "", login: user.login)
                }
            }
        }
    }
    
    func saveSearchOnStorage(name: String, login: String) {
        let existingList = MyStorageManager().getObjectList()
        var objectList = existingList
        let newSearch = UserSearched(name: name, login: login, id: UUID())
        objectList.append(newSearch)

        // Save the updated list in storage
        MyStorageManager().saveObjectList(objectList)
    }



    func fetchUser(url: String, completion: @escaping (User) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let user = try? JSONDecoder().decode(User.self, from: data) {
                completion(user)
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    func fetchRepos(url: String, completion: @escaping ([Repository]) -> Void) {
        guard let url = URL(string: url) else {
            print("Invalid URL")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let repos = try? JSONDecoder().decode([Repository].self, from: data) {
                completion(repos)
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }.resume()
    }

    struct User: Codable {
        var name: String?
        var login: String
        var followers: Int
        var following: Int
        var public_repos: Int
        var avatar_url: String
    }
  }



struct UserCard: View {
    var userData: UserData

    var body: some View {
        VStack {
            Text(userData.name)
                .font(.title)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
            Text(userData.login)
                .font(.headline)
                .foregroundColor(.white)
            
            WebImage(url: URL(string: userData.avatarURL))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .clipShape(Circle())
            HStack {
                UserStat(title: "Followers", value: userData.followers)
                UserStat(title: "Following", value: userData.following)
                UserStat(title: "Public Repos", value: userData.publicRepos)
            }
            .padding()
            RepositoriesView(repositories: userData.repositories)
        }
        .border(Color("#094074"), width: 3)
    }
}

  struct RepositoriesView: View {
      var repositories: [Repository]

      var body: some View {
          VStack(alignment: .center) {
              Text("Repositories")
                  .font(.title)
                  .fontWeight(.bold)
                  .padding()
                  .foregroundColor(.white)

              ForEach(repositories, id: \.name) { repo in
                  RepositoryCard(repository: repo)
              }
          }
          .padding()
          .frame(width: .infinity)
      }
  }

struct RepositoryCard: View {
    var repository: Repository

    var body: some View {
        VStack(alignment: .center) {
            Text(repository.name)
                .font(.headline)
                .fontWeight(.bold)
                .padding()
                .foregroundColor(.white)
            Text(repository.language ?? "Not Informed")
                .font(.subheadline)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            Button("Link to Repository") {
                if let url = URL(string: repository.html_url) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(BorderlessButtonStyle())
            .padding()
            .background(Color("#3c6997"))
            .frame(maxWidth: .infinity)
            .foregroundColor(.white)
        }
        .padding()
        .background(Color("#094074"))
        .padding(.bottom, 10)
        .frame(maxWidth: .infinity)
    }
}


  struct UserStat: View {
      var title: String
      var value: String

      var body: some View {
          VStack {
              Text(title)
                  .font(.subheadline)
                  .foregroundColor(.white)
                  .padding(.horizontal, 5)
              Text(value)
                  .font(.headline)
                  .fontWeight(.bold)
                  .foregroundColor(.white)
                  .padding(.top, 5)
          }
      }
  }

  // Placeholder data models
  struct UserData {
      var name: String
      var login: String
      var followers: String
      var following: String
      var publicRepos: String
      var avatarURL: String
      var repositories: [Repository]
  }

struct Repository: Codable {
    var name: String
    var language: String?
    var html_url: String
}

#Preview {
    SearchView()
}
