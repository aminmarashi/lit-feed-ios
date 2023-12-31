//
//  ToolbarView.swift
//  feed
//
//  Created by Amin Marashi on 06/11/2023.
//

import Combine
import SwiftUI
struct FeedsResponse: Decodable {
  let message: String
  let data: [Feed]
}

struct ToolbarView: View {
  let accessToken: String?
  @Binding var selectedFeed: Feed?
  @State private var cancellable: AnyCancellable?
  @State private var feeds: [Feed] = []
  @State private var errorMessage: String?
  var body: some View {
    if let errorMessage = errorMessage {
      List([ListableError(message: errorMessage)]) { error in
        Text(error.message)
          .navigationTitle("Feeds")
          .accessibilityIdentifier("ToolbarView")
      }
      .refreshable {
        loadFeeds()
      }
    } else {
      List(feeds, selection: $selectedFeed) { feed in
        NavigationLink(feed.name, value: feed)
      }
      .navigationTitle("Feeds")
      .accessibilityIdentifier("ToolbarView")
      .onAppear {
        loadFeeds()
      }
      .refreshable {
        loadFeeds()
      }
    }
  }
}

extension ToolbarView {
  func loadFeeds() {
    errorMessage = nil
    // TODO: Show an error to the user if the accessToken is nil
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

    // TODO: Show an error to the user if the request fails
    cancellable = URLSession.shared.dataTaskPublisher(for: request)
      .map { $0.data }
      .decode(type: FeedsResponse.self, decoder: JSONDecoder())
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
        self.feeds = response.data
      })
  }
}

#Preview {
  NavigationSplitView {
    ToolbarView(accessToken: nil, selectedFeed: .constant(sampleFeeds[0]))
  } detail: {
    Text("some text")
  }
}
