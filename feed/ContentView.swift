//
//  ContentView.swift
//  feed
//
//  Created by Amin Marashi on 27/10/2023.
//

import SwiftUI

struct ContentView: View {
  @State private var selectedFeed: Feed?
  @State private var selectedArticle: Article?
  var body: some View {
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
      Text("under construction filters")
        .tabItem {
          Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
        }
      Text("under construction settings")
        .tabItem {
          Label("Settings", systemImage: "gear")
        }
    }
  }
}

#Preview {
  ContentView()
}
