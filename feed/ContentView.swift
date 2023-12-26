//
//  ContentView.swift
//  feed
//
//  Created by Amin Marashi on 27/10/2023.
//

import Auth0
import Combine
import SwiftUI

struct FeedsResponse: Decodable {
  let message: String
  let data: [Feed]
}

struct ContentView: View {
  @State var user: User?
  @State private var selectedFeed: Feed?
  @State private var selectedArticle: Article?
  @State private var feeds: [Feed] = []
  @State private var cancellable: AnyCancellable?

  var body: some View {
    if let user = self.user {
      TabView {
        NavigationSplitView {
          ToolbarView(feeds: feeds, selectedFeed: $selectedFeed)
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
        }.onAppear {
          loadFeeds()
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

  func loadFeeds() {
    let url = URL(string: "http://localhost:3000/api/feeds")!
    cancellable = URLSession.shared.dataTaskPublisher(for: url)
      .map { $0.data }
      .decode(type: FeedsResponse.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          print("Error: \(error)")
        case .finished:
          break
        }
      }, receiveValue: { response in
        self.feeds = response.data
      })
  }
}

extension ContentView {
  func login() {
    Auth0
      .webAuth()
      .start { result in
        switch result {
        case let .success(credentials):
          self.user = User(from: credentials.idToken)
        case let .failure(error):
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
        case let .failure(error):
          print("Failed with: \(error)")
        }
      }
  }
}

#Preview {
  ContentView(user: User(id: "id", email: "email", picture: "picture"))
}
