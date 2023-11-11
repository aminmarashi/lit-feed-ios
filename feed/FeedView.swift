//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI

struct FeedView: View {
  let feed: Feed
  @Binding var selectedArticle: Article?
  var articles: [Article] {
    return feed.articles
  }

  var body: some View {
    VStack(alignment: .leading) {
      HStack {
        VStack(alignment: .leading) {
          Text("\(articles.filter { !$0.isRead }.count) unread")
            .font(.subheadline)
            .foregroundColor(.gray)
        }
        .padding(.leading, 10)
        
        Spacer()
        Button(action: {
          // Handle eye button tap
        }) {
          Image(systemName: "eye")
            .font(.headline)
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
        .buttonStyle(PlainButtonStyle())
        Button(action: {
          // Handle magnifying glass button tap
        }) {
          Image(systemName: "magnifyingglass")
            .font(.headline)
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
        .buttonStyle(PlainButtonStyle())
        Button(action: {
          // Handle checkmark button tap
        }) {
          Image(systemName: "checkmark.circle")
            .font(.headline)
            .foregroundColor(.primary)
        }
        .padding(.trailing, 10)
        .buttonStyle(PlainButtonStyle())
      }
      .frame(height: 20)
      
      List(articles, selection: $selectedArticle) { article in
        ArticleRow(article: article)
      }
      .listStyle(PlainListStyle())
    }
    .navigationTitle(feed.name)
    .padding(.vertical, 10)
    .padding(.horizontal, 3)
    .accessibilityIdentifier("FeedView")
  }
}

#Preview {
  NavigationStack {
    FeedView(feed: sampleFeeds[0], selectedArticle: .constant(sampleFeeds[0].articles[0]))
  }
}
