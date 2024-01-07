//
//  Article.swift
//  feed
//
//  Created by Amin Marashi on 12/11/2023.
//

import Foundation

struct Article: Identifiable, Hashable, Decodable, Encodable {
  let id: String
  let image: String?
  let title: String
  let summary: String
  let feedName: String
  let href: String
  let feedId: String?
  let duration: String?
  var isRead: Bool
  var isSaved: Bool
  let date: String?
  let content: String?
}

let articleSummary = "<p>Article URL: <a href=\"https://austinhenley.com/blog/challengingprojects.html\">https://austinhenley.com/blog/challengingprojects.html</a></p><p>Comments URL: <a href=\"https://news.ycombinator.com/item?id=38768678\">https://news.ycombinator.com/item?id=38768678</a></p><p>Points: 241</p><p># Comments: 107</p>"

let sampleArticles = [
  Article(id: "1", image: "article1", title: "Article 1 Title that is now a very long title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "1h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "2", image: "article2", title: "Article 2 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "2h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "3", image: "article3", title: "Article 3 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "3h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "4", image: "article4", title: "Article 4 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "4h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "5", image: "article5", title: "Article 5 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "5h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "6", image: "article5", title: "Article 5 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "5h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "7", image: "article6", title: "Article 6 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "6h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "8", image: "article7", title: "Article 7 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "7h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
  Article(id: "9", image: "article8", title: "Article 8 Title", summary: articleSummary, feedName: "Hacker News test", href: "https://news.ycombinator.com", feedId: "1", duration: "8h", isRead: false, isSaved: false, date: "2023-12-26T07:28:58.508Z", content: ""),
]
