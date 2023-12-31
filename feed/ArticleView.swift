//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI
import WebKit

class Coordinator: NSObject, WKNavigationDelegate {
  var parent: WebView

  init(_ parent: WebView) {
    self.parent = parent
  }

  func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
      parent.openURL = IdentifiableURL(url: url)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}

/** Render HTML content (make links clickable) from article.content if available, otherwise render article.summary */
struct WebView: UIViewRepresentable {
  let htmlContent: String
  @Binding var openURL: IdentifiableURL?
  @Environment(\.colorScheme) var colorScheme
  func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = context.coordinator
    let textColor = colorScheme == .dark ? "white" : "black"
    let backgroundColor = colorScheme == .dark ? "black" : "white"
    let modifiedFont = """
    <html>
    <head>
        <style>
            body {
                font-size:300%;
                font-family: -apple-system, HelveticaNeue;
                color: \(textColor);
                background-color: \(backgroundColor);
            }
        </style>
    </head>
    <body>
        \(htmlContent)
    </body>
    </html>
    """
    webView.loadHTMLString(modifiedFont, baseURL: nil)
    return webView
  }

  func updateUIView(_: WKWebView, context _: Context) {}
}

class NavigationDelegate: NSObject, WKNavigationDelegate {
  func webView(_: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
    if navigationAction.navigationType == .linkActivated, let url = navigationAction.request.url {
      UIApplication.shared.open(url)
      decisionHandler(.cancel)
    } else {
      decisionHandler(.allow)
    }
  }
}

struct IdentifiableURL: Identifiable {
  let id = UUID()
  let url: URL
}

struct ArticleView: View {
  let article: Article?
  let accessToken: String?
  @State private var safariURL: IdentifiableURL? = nil
  var body: some View {
    if let foundArticle = article {
      VStack(alignment: .leading) {
        if let image = foundArticle.image {
          AsyncImage(url: URL(string: image)) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
          }
          .frame(maxWidth: .infinity)
        }
        Link(destination: URL(string: foundArticle.href)!) {
          Text(foundArticle.title).font(.largeTitle)
            .fontWeight(.bold)
            .minimumScaleFactor(0.1)
            .foregroundStyle(.primary)
            .multilineTextAlignment(.leading)
            .lineLimit(2)
        }
        .environment(\.openURL, OpenURLAction { url in
          safariURL = IdentifiableURL(url: url)

          return .handled
        })

        HStack {
          Text("Published on")
            .font(.subheadline)
            .foregroundColor(.secondary)
          Text(foundArticle.feedName)
            .font(.subheadline)
            .foregroundColor(.primary)
            .lineLimit(1)
          Text(formatDate(foundArticle.date))
            .font(.subheadline)
            .foregroundColor(.secondary)
            .lineLimit(1)
        }
        WebView(htmlContent: foundArticle.content ?? foundArticle.summary, openURL: $safariURL)
        Spacer()
      }
      .padding(.horizontal, 10)
      .sheet(item: $safariURL) { identifiableURL in
        SafariView(url: identifiableURL.url)
      }
      .onAppear {
        markArticleAsRead()
      }
    } else {
      Text("No articles found")
    }
  }
}

extension ArticleView {
  func formatDate(_ dateString: String?) -> String {
    // input dateString format: 2023-12-26T07:28:58.508Z
    // output format: 12:01 PM - 23 Dec 26
    guard let dateString = dateString else {
      return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    guard let date = dateFormatter.date(from: dateString) else {
      return ""
    }
    dateFormatter.dateFormat = "h:mm a - MMM d, yy"
    return dateFormatter.string(from: date)
  }

  func markArticleAsRead() {
    guard let accessToken = accessToken, let article = article else {
      return
    }

    #if targetEnvironment(simulator)
      let baseUrl = URL(string: "http://localhost:3000")
    #else
      let baseUrl = URL(string: "https://feed.lit.codes")
    #endif
    guard let baseUrl = baseUrl else {
      return
    }

    let url = baseUrl.appendingPathComponent("/api/articles/\(article.id)")
    var request = URLRequest(url: url)
    request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "PATCH"
    let readArticle = Article(id: article.id, image: article.image, title: article.title, summary: article.summary, feedName: article.feedName, href: article.href, feedId: article.feedId, duration: article.duration, isRead: true, isSaved: article.isSaved, date: article.date, content: article.content)
    request.httpBody = try? JSONEncoder().encode(readArticle)
    URLSession.shared.dataTask(with: request) { _, response, error in
      if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
        print("Successfully marked article \(article.id) as read")
      } else if let error = error {
        print("Failed to mark article as read: \(error)")
      }
    }.resume()
  }
}

#Preview {
  NavigationStack {
    ArticleView(article: sampleArticles[0], accessToken: nil)
  }
}
