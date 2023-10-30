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
        VStack {
            if let image = UIImage(named: article?.image ?? "") {
              Image(uiImage: image)
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .opacity(article?.isRead ?? false ? 0.5 : 1.0)
                .padding(.leading, -8)
            } else {
              Image(systemName: "photo")
                .resizable()
                .frame(width: 200, height: 200)
                .cornerRadius(10)
                .foregroundColor(.gray)
                .padding(.leading, -8)
            }
            Text(article?.title ?? "")
            Text(article?.summary ?? "")
        }
    }
}

#Preview {
    ArticleView(article: sampleArticles[0])
}
