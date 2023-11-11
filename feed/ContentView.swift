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

struct Feed: Identifiable, Hashable {
  let id = UUID()
  let image: String?
  let href: String?
  let name: String
  let unread: Int
  let articles: [Article]
}

let sampleArticles = [
  Article(image: "article1", title: "Article 1 Title", summary: "Article 1 Summary", feedName: "Feed 1", duration: "1h ago"),
  Article(image: "article2", title: "Article 2 Title", summary: "Article 2 Summary", feedName: "Feed 2", duration: "2h ago"),
  Article(image: "article3", title: "Article 3 Title", summary: "Article 3 Summary", feedName: "Feed 3", duration: "3h ago"),
  Article(image: "article4", title: "Article 4 Title", summary: "Article 4 Summary", feedName: "Feed 4", duration: "4h ago"),
  Article(image: "article5", title: "Article 5 Title", summary: "Article 5 Summary", feedName: "Feed 5", duration: "5h ago"),
  Article(image: "article5", title: "Article 5 Title", summary: "Article 5 Summary", feedName: "Feed 5", duration: "5h ago"),
  Article(image: "article6", title: "Article 6 Title", summary: "Article 6 Summary", feedName: "Feed 6", duration: "6h ago"),
  Article(image: "article7", title: "Article 7 Title", summary: "Article 7 Summary", feedName: "Feed 7", duration: "7h ago"),
  Article(image: "article8", title: "Article 8 Title", summary: "Article 8 Summary", feedName: "Feed 8", duration: "8h ago"),
  Article(image: "article9", title: "Article 9 Title", summary: "Article 9 Summary", feedName: "Feed 9", duration: "9h ago"),
]
let sampleFeeds = [
  Feed(image: nil, href: nil, name: "All Articles", unread: 0, articles: sampleArticles),
  Feed(image: "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?202106030101", href: "https://www.apple.com", name: "Apple", unread: 0, articles: sampleArticles),
  Feed(image: "https://news.ycombinator.com/favicon.ico", href: "https://news.ycombinator.com", name: "Hacker News", unread: 0, articles: sampleArticles),
  Feed(image: "https://www.redditstatic.com/desktop2x/img/favicon/favicon-32x32.png", href: "https://www.reddit.com", name: "Reddit", unread: 0, articles: sampleArticles),
  Feed(image: "https://www.youtube.com/s/desktop/1b1d0b1f/img/favicon_32.png", href: "https://www.youtube.com", name: "YouTube", unread: 0, articles: sampleArticles),
]
