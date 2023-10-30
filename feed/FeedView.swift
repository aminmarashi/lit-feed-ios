//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI

struct FeedView: View {
  let articles: [Article]
  @Binding var selectedArticle: Article?
  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        Button(action: {
          // Handle hamburger button tap
        }) {
          Image(systemName: "line.horizontal.3")
            .font(.system(size: 20))
            .foregroundColor(.primary)
        }
        .padding(.leading, 10)
        Spacer()
        Button(action: {
          // Handle eye button tap
        }) {
          Image(systemName: "eye")
            .font(.system(size: 20))
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
        Button(action: {
          // Handle magnifying glass button tap
        }) {
          Image(systemName: "magnifyingglass")
            .font(.system(size: 20))
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
        Button(action: {
          // Handle checkmark button tap
        }) {
          Image(systemName: "checkmark.circle")
            .font(.system(size: 20))
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
      }
      .frame(height: 20)
      VStack(alignment: .leading) {
        Text("All articles")
          .font(.largeTitle)
          .fontWeight(.bold)
        Text("\(articles.filter { !$0.isRead }.count) unread")
          .font(.subheadline)
          .foregroundColor(.gray)
      }
      .padding(.leading, 10)
      List(selection: $selectedArticle) {
        ForEach(articles) { article in
          ArticleRow(article: article)
        }
      }
      .listStyle(PlainListStyle())
    }
    .padding(.vertical, 10)
    .padding(.horizontal, 3)
  }
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

#Preview {
  // preview with the third article selected
    FeedView(articles: sampleArticles, selectedArticle: .constant(sampleArticles[2]))
}
