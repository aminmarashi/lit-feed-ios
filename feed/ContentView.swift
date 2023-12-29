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
  @State private var accessToken: String?

  var body: some View {
    if let user = self.user {
      TabView {
        NavigationSplitView {
          ToolbarView(feeds: feeds, selectedFeed: $selectedFeed)
            .navigationDestination(for: Feed.self) { feed in
              FeedView(feed: feed, accessToken: accessToken, selectedArticle: $selectedArticle)
            }
        } content: {
          if let existingSelectedFeed = selectedFeed {
            FeedView(feed: existingSelectedFeed, accessToken: accessToken, selectedArticle: $selectedArticle)
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
      Button("Login", action: self.login).onOpenURL { url in
        WebAuthentication.resume(with: url)
      }
    }
  }

  func loadFeeds() {
    guard let accessToken = accessToken else {
      return
    }
    #if targetEnvironment(simulator)
      let url = URL(string: "http://localhost:3000/api/feeds")
    #else
      let url = URL(string: "https://feed.lit.codes/api/feeds")
    #endif

    guard let url = url else {
      return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    cancellable = URLSession.shared.dataTaskPublisher(for: request)
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
      .provider(WebAuthentication.safariProvider()) // Use SFSafariViewController
      .start { result in
        switch result {
        case let .success(credentials):
          self.user = User(from: credentials.idToken)
          self.accessToken = credentials.accessToken
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
          self.accessToken = nil
        case let .failure(error):
          print("Failed with: \(error)")
        }
      }
  }
}

#Preview {
  ContentView(user: User(id: "id", email: "email", picture: "picture"))
}
