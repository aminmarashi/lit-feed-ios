//
//  Feed.swift
//  feed
//
//  Created by Amin Marashi on 12/11/2023.
//

import Foundation

struct Feed: Identifiable, Hashable, Decodable {
  let id: String
  let userId: String
  let image: String?
  let href: String
  let name: String
  let unread: Int?
  let updatedAt: String?
}

let sampleFeeds = [
  Feed(id: UUID().uuidString, userId: "1", image: "", href: "", name: "All Articles", unread: 0, updatedAt: ""),
  Feed(id: UUID().uuidString, userId: "1", image: "https://www.apple.com/ac/structured-data/images/knowledge_graph_logo.png?202106030101", href: "https://www.apple.com", name: "Apple", unread: 0, updatedAt: "2023-11-11 11:11:11"),
  Feed(id: UUID().uuidString, userId: "1", image: "https://news.ycombinator.com/favicon.ico", href: "https://news.ycombinator.com", name: "Hacker News", unread: 0, updatedAt: "2023-11-11 11:11:11"),
  Feed(id: UUID().uuidString, userId: "1", image: "https://www.redditstatic.com/desktop2x/img/favicon/favicon-32x32.png", href: "https://www.reddit.com", name: "Reddit", unread: 0, updatedAt: "2023-11-11 11:11:11"),
  Feed(id: UUID().uuidString, userId: "1", image: "https://www.youtube.com/s/desktop/1b1d0b1f/img/favicon_32.png", href: "https://www.youtube.com", name: "YouTube", unread: 0, updatedAt: "2023-11-11 11:11:11"),
]
