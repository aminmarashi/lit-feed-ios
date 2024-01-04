import SwiftUI

struct ArticleRow: View {
  let article: Article

  // Calculated property called relativeDateFromNow that returns a string for relatiive date from now from the article's date
  var relativeDateFromNow: String {
    let formatter = RelativeDateTimeFormatter()
    formatter.unitsStyle = .full

    guard let date = article.date else {
      return ""
    }

    // Convert date string (JS ISO format) to Date object
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let articleDate = dateFormatter.date(from: date) else {
      return ""
    }

    return formatter.localizedString(for: articleDate, relativeTo: Date())
  }

  var body: some View {
    HStack {
      VStack(alignment: .leading) {
        NavigationLink(article.title, value: article)
          .foregroundColor(.primary)
          .font(.headline)
          .fontWeight(.bold)
          .opacity(article.isRead ? 0.5 : 1.0)

        Text(article.summary)
          .font(.subheadline)
          .opacity(article.isRead ? 0.5 : 1.0)
          .lineLimit(2)
          .foregroundColor(.primary)
        HStack {
          Text("Published on")
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
            .foregroundColor(.secondary)
          Text(article.feedName)
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
            .foregroundColor(.accentColor)
            .lineLimit(1)
          Text(relativeDateFromNow)
            .font(.caption)
            .opacity(article.isRead ? 0.5 : 1.0)
            .foregroundColor(.secondary)
            .lineLimit(1)
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
        ArticleView(article: article, accessToken: nil)
      }
  }
}
