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
  @State private var offset = 0
  @State private var showProgress = false
  @State private var showProgressAtTop = false
  let limit = 10

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
      VStack {
        List(articles, selection: $selectedArticle) { article in
          ArticleRow(article: article)
            .onAppear {
              if articles.last == article {
                showProgress = true
                offset += limit
                loadArticles()
              }
            }
            .onTapGesture {
              if let index = articles.firstIndex(where: { $0.id == article.id }) {
                articles[index].isRead = true
                selectedArticle = articles[index]
              }
            }
        }
        .listStyle(PlainListStyle())
        .onAppear {
          loadArticles()
        }
        .refreshable {
          refreshFeed()
        }
        .overlay(
          Group {
            if showProgressAtTop {
              ProgressView()
                .scaleEffect(2.0, anchor: .center)
                .progressViewStyle(CircularProgressViewStyle(tint: .primary))
            }
          }
        )
        if showProgress {
          ProgressView()
            .scaleEffect(1.5, anchor: .center)
        }
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
    let articlesPath = baseUrl.appendingPathComponent("api/feeds/\(feed.id)/articles")
    var urlComponents = URLComponents(url: articlesPath, resolvingAgainstBaseURL: true)
    urlComponents?.queryItems = [
      URLQueryItem(name: "offset", value: "\(offset)"),
      URLQueryItem(name: "limit", value: "\(limit)"),
    ]
    guard let articlesUrl = urlComponents?.url else {
      return
    }
    var request = URLRequest(url: articlesUrl)
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    cancellable = URLSession.shared.dataTaskPublisher(for: request)
      .tryMap { data, response in
        if let httpResponse = response as? HTTPURLResponse {
          if httpResponse.statusCode != 200 {
            // print the response data as plaintext
            if let responseString = String(data: data, encoding: .utf8) {
              print("responseString: \(responseString)")
            }
          }
          if httpResponse.statusCode == 200 {
            return data
          } else if httpResponse.statusCode == 401 {
            throw URLError(.userAuthenticationRequired)
          } else if httpResponse.statusCode == 403 {
            throw URLError(.userAuthenticationRequired)
          } else if httpResponse.statusCode == 404 {
            throw URLError(.badURL)
          } else {
            throw URLError(.badServerResponse)
          }
        } else {
          throw URLError(.unknown)
        }
      }
      .decode(type: ArticlesResponse.self, decoder: JSONDecoder())
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case let .failure(error):
          print("Error: \(error)")
          self.errorMessage = error.localizedDescription
        case .finished:
          showProgressAtTop = false
          showProgress = false
        }
      }, receiveValue: { response in
        print("data json: \(response.data)")
        articles.append(contentsOf: response.data)
      })
  }

  func refreshFeed() {
    showProgressAtTop = true
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
        self.articles = []
        self.offset = 0
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
