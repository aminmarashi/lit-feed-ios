//
//  Article.swift
//  feed
//
//  Created by Amin Marashi on 12/11/2023.
//

import Foundation

struct Article: Identifiable, Hashable, Decodable {
  let id: String
  let image: String?
  let title: String
  let summary: String
  let feedName: String
  let feedId: String?
  let duration: String?
  let isRead: Bool
  let isSaved: Bool
  let date: String?
  let content: String?
}

let sampleArticles = [
  Article(id: "1", image: "article1", title: "Article 1 Title", summary: "Article 1 Summary", feedName: "Feed 1", feedId: "1", duration: "1h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "2", image: "article2", title: "Article 2 Title", summary: "Article 2 Summary", feedName: "Feed 1", feedId: "1", duration: "2h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "3", image: "article3", title: "Article 3 Title", summary: "Article 3 Summary", feedName: "Feed 1", feedId: "1", duration: "3h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "4", image: "article4", title: "Article 4 Title", summary: "Article 4 Summary", feedName: "Feed 1", feedId: "1", duration: "4h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "5", image: "article5", title: "Article 5 Title", summary: "Article 5 Summary", feedName: "Feed 1", feedId: "1", duration: "5h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "6", image: "article5", title: "Article 5 Title", summary: "Article 5 Summary", feedName: "Feed 1", feedId: "1", duration: "5h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "7", image: "article6", title: "Article 6 Title", summary: "Article 6 Summary", feedName: "Feed 1", feedId: "1", duration: "6h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "8", image: "article7", title: "Article 7 Title", summary: "Article 7 Summary", feedName: "Feed 1", feedId: "1", duration: "7h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
  Article(id: "9", image: "article8", title: "Article 8 Title", summary: "Article 8 Summary", feedName: "Feed 1", feedId: "1", duration: "8h ago", isRead: false, isSaved: false, date: "Thu, 21 Dec 2023 20:26:39 +0000", content: ""),
]
