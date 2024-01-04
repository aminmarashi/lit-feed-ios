//
//  ContentView.swift
//  feed
//
//  Created by Amin Marashi on 27/10/2023.
//

import Auth0
import SwiftUI

struct ContentView: View {
  @State var user: User?
  @State private var selectedFeed: Feed?
  @State private var selectedArticle: Article?
  @State private var accessToken: String?
  let credentialsManager = CredentialsManager(authentication: Auth0.authentication())

  var body: some View {
    Group {
      if let user = self.user {
        TabView {
          NavigationSplitView {
            ToolbarView(accessToken: accessToken, selectedFeed: $selectedFeed)
              .navigationDestination(for: Feed.self) { feed in
                FeedView(feed: feed, accessToken: accessToken, selectedArticle: $selectedArticle)
              }
          } content: {
            if let existingSelectedFeed = selectedFeed {
              FeedView(feed: existingSelectedFeed, accessToken: accessToken, selectedArticle: $selectedArticle)
                .navigationDestination(for: Article.self) { article in
                  ArticleView(article: article, accessToken: accessToken)
                }
            } else {
              Text("Select a feed to view articles")
            }
          } detail: {
            ArticleView(article: selectedArticle, accessToken: accessToken)
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
        if !credentialsManager.canRenew() {
          Button("Login", action: self.login)
        }
      }
    }
    .onOpenURL { url in
      WebAuthentication.resume(with: url)
    }
    .onAppear(perform: {
      guard self.user == nil else {
        print("User already loaded")
        return
      }

      if credentialsManager.canRenew() {
        credentialsManager.renew { credentialsResult in
          print("Renewing credentials")
          let credentials = try? credentialsResult.get()
          guard let credentials = credentials else {
            print("Failed to renew credentials")
            return
          }
          self.user = User(from: credentials.idToken)
          self.accessToken = credentials.accessToken
          print("Credentials renewed successfully")
        }
      }
    })
  }
}

extension ContentView {
  func login() {
    Auth0
      .webAuth()
      .scope("openid profile email offline_access")
      .provider(WebAuthentication.safariProvider()) // Use SFSafariViewController
      .start { result in
        switch result {
        case let .success(credentials):
          self.user = User(from: credentials.idToken)
          self.accessToken = credentials.accessToken
          let didStore = credentialsManager.store(credentials: credentials)
          if !didStore {
            print("Failed to store credentials")
          } else {
            print("Credentials stored successfully")
          }
        case let .failure(error):
          print("Failed with: \(error)")
        }
      }
  }

  func logout() {
    Auth0
      .webAuth()
      .provider(WebAuthentication.safariProvider()) // Use SFSafariViewController
      .clearSession { result in
        switch result {
        case .success:
          self.user = nil
          self.accessToken = nil
          self.credentialsManager.clear()
        case let .failure(error):
          print("Failed with: \(error)")
        }
      }
  }
}

#Preview {
  ContentView(user: User(id: "id", email: "email", picture: "picture"))
}
