import SwiftUI

struct ArticleRow: View {
  let article: Article

  var body: some View {
    HStack {
      Image(systemName: "photo")
        .resizable()
        .frame(width: 50, height: 50)
        .cornerRadius(10)
        .foregroundColor(.gray)
        .padding(.leading, -8)

      VStack(alignment: .leading) {
        NavigationLink(article.title, value: article)
          .foregroundColor(.primary)
          .font(.headline)
          .fontWeight(.bold)
          .opacity(article.isRead ? 0.5 : 1.0)

        Text(article.summary)
          .font(.subheadline)
          .opacity(article.isRead ? 0.5 : 1.0)
        HStack {
          Text(article.feedName)
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
          Text("/")
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
          Text(article.duration)
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
        }
      }
    }
    .frame(height: 73)
    .tag(article)
  }
}

#Preview {
  NavigationStack {
    ArticleRow(article: sampleArticles[1])
      .navigationDestination(for: Article.self) { article in
        ArticleView(article: article)
      }
  }
}
