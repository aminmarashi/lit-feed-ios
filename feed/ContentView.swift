//
//  ContentView.swift
//  feed
//
//  Created by Amin Marashi on 27/10/2023.
//

import SwiftUI
import Auth0

struct ContentView: View {
  @State var user: User?
  @State private var selectedFeed: Feed?
  @State private var selectedArticle: Article?
  var body: some View {
    if let user = self.user {
        
        TabView {
          NavigationSplitView {
            ToolbarView(feeds: sampleFeeds, selectedFeed: $selectedFeed)
              .navigationDestination(for: Feed.self) { feed in
                FeedView(feed: feed, selectedArticle: $selectedArticle)
              }
          } content: {
            if let existingSelectedFeed = selectedFeed {
              FeedView(feed: existingSelectedFeed, selectedArticle: $selectedArticle)
                .navigationDestination(for: Article.self) { article in
                  ArticleView(article: article)
                }
            } else {
              Text("Select a feed to view articles")
            }
          } detail: {
            ArticleView(article: selectedArticle)
          }
          .tabItem {
            Label("Feeds", systemImage: "list.bullet.rectangle.portrait")
          }
          Text("under construction saved")
            .tabItem {
              Label("Saved", systemImage: "star")
            }
          Text("under construction filters")
            .tabItem {
              Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
            }
          Text("under construction settings")
            .tabItem {
              Label("Settings", systemImage: "gear")
            }
          VStack {
            ProfileView(user: user)
            Button("Logout", action: self.logout)
              .padding(20)
          }
            .tabItem {
              Label("Profile", systemImage: "person.crop.circle")
            }
        
      }
    } else {
      Button("Login", action: self.login)
  }
  }
}
extension ContentView {
    func login() {
        Auth0
            .webAuth()
            .start { result in
                switch result {
                case .success(let credentials):
                    self.user = User(from: credentials.idToken)
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }

    func logout() {
        Auth0
            .webAuth()
            .clearSession { result in
                switch result {
                case .success:
                    self.user = nil
                case .failure(let error):
                    print("Failed with: \(error)")
                }
            }
    }
}

#Preview {
  ContentView(user: User(id: "id", email: "email", picture: "picture"))
}
