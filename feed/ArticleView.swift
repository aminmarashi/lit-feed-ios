//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI

struct ArticleView: View {
  let article: Article?
  var body: some View {
    if let foundArticle = article {
      VStack {
        Image(systemName: "photo")
          .resizable()
          .frame(width: 200, height: 200)
          .cornerRadius(10)
          .foregroundColor(.gray)
          .padding(.leading, -8)
      }
      Text(foundArticle.summary)

        .navigationTitle(foundArticle.title)
    } else {
      Text("No articles found")
    }
  }
}

#Preview {
  NavigationStack {
    ArticleView(article: sampleArticles[0])
  }
}
