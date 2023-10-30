import SwiftUI

struct ArticleRow: View {
  let article: Article

  var body: some View {
    HStack {
      if let image = UIImage(named: article.image) {
        Image(uiImage: image)
          .resizable()
          .frame(width: 50, height: 50)
          .cornerRadius(10)
          .opacity(article.isRead ? 0.5 : 1.0)
          .padding(.leading, -8)
      } else {
        Image(systemName: "photo")
          .resizable()
          .frame(width: 50, height: 50)
          .cornerRadius(10)
          .foregroundColor(.gray)
          .padding(.leading, -8)
      }
      VStack(alignment: .leading) {
        Text(article.title)
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

struct Article: Identifiable, Hashable {
  let id = UUID()
  let image: String
  let title: String
  let summary: String
  let feedName: String
  let duration: String
  var isRead: Bool = false
}

#Preview {
    ArticleRow(article: sampleArticles[1])
}
