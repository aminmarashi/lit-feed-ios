//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import Combine
import SwiftUI

struct ArticlesResponse: Decodable {
  let message: String
  let data: [Article]
}

struct FeedView: View {
  let feed: Feed
  let accessToken: String?
  @Binding var selectedArticle: Article?
  @State private var articles: [Article] = []
  @State private var cancellable: AnyCancellable?
  @State private var errorMessage: String?

  var body: some View {
    if let errorMessage = errorMessage {
      List([ListableError(message: errorMessage)]) { error in
        Text(error.message)
          .navigationTitle(feed.name)
          .accessibilityIdentifier("FeedView")
      }
      .refreshable {
        refreshFeed()
      }
    } else {
      List(articles, selection: $selectedArticle) { article in
        ArticleRow(article: article)
      }
      .listStyle(PlainListStyle())
      .onAppear {
        loadArticles()
      }
      .refreshable {
        refreshFeed()
      }
      .navigationTitle(feed.name)
      .padding(.vertical, 10)
      .padding(.horizontal, 3)
      .accessibilityIdentifier("FeedView")
    }
  }
}

extension FeedView {
  func loadArticles() {
    errorMessage = nil
    guard let accessToken = accessToken else {
      return
    }
    #if targetEnvironment(simulator)
      let baseUrl = URL(string: "http://localhost:3000")
    #else
      let baseUrl = URL(string: "https://feed.lit.codes")
    #endif
    guard let baseUrl = baseUrl else {
      return
    }
    let articlesUrl = baseUrl.appendingPathComponent("api/feeds/\(feed.id)/articles")
    var request = URLRequest(url: articlesUrl)
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    cancellable = URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          print("Error: \(error)")
          self.errorMessage = error.localizedDescription
        case .finished:
          break
        }
      }, receiveValue: { response in
        self.articles = response.data
      })
  }

  func refreshFeed() {
    errorMessage = nil
    guard let accessToken = accessToken else {
      return
    }

    #if targetEnvironment(simulator)
      let baseUrl = URL(string: "http://localhost:3000")
    #else
      let baseUrl = URL(string: "https://feed.lit.codes")
    #endif

    guard let baseUrl = baseUrl else {
      return
    }

    let refreshUrl = baseUrl.appendingPathComponent("api/feeds/\(feed.id)/refresh")
    var request = URLRequest(url: refreshUrl)
    request.httpMethod = "POST"
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    let task = URLSession.shared.dataTaskPublisher(for: request)
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          self.errorMessage = error.localizedDescription
        case .finished:
          break
        }
      }, receiveValue: { _ in
        self.loadArticles()
      })

    cancellable = AnyCancellable(task)
  }
}

#Preview {
  NavigationStack {
    FeedView(feed: sampleFeeds[0], accessToken: nil, selectedArticle: .constant(sampleArticles[0]))
  }
}
