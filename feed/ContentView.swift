//
//  ContentView.swift
//  feed
//
//  Created by Amin Marashi on 27/10/2023.
//

import SwiftUI


struct ContentView: View {
    @State var articles: [Article] = sampleArticles
    @State var selectedArticle: Article?
  var body: some View {
      NavigationSplitView {
          SidebarView()
      } content: {
          FeedView(articles: articles, selectedArticle: $selectedArticle)
      } detail: {
          ArticleView(article: selectedArticle)
      }
  }
}

#Preview {
  ContentView()
}
