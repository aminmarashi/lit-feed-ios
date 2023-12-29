//
//  ArticleView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI
import WebKit

/** Render HTML content (make links clickable) from article.content if available, otherwise render article.summary */
struct WebView: UIViewRepresentable {
  let htmlContent: String
  var navigationDelegate: WKNavigationDelegate? = NavigationDelegate()
  @Environment(\.colorScheme) var colorScheme

  func makeUIView(context _: Context) -> WKWebView {
    let webView = WKWebView()
    webView.navigationDelegate = navigationDelegate
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

struct ArticleView: View {
  let article: Article?
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
        .padding(.horizontal, 20)
        WebView(htmlContent: foundArticle.content ?? foundArticle.summary)
          .padding(.horizontal, 20)

        Spacer()
      }
      .navigationTitle(foundArticle.title)
    } else {
      Text("No articles found")
    }
  }

  func formatDate(_ dateString: String?) -> String {
    // input dateString format: Thu, 21 Dec 2023 20:26:39 +0000
    // output format: 12:01 PM - 23 Dec 26
    guard let dateString = dateString else {
      return ""
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"
    let date = dateFormatter.date(from: dateString)
    dateFormatter.dateFormat = "hh:mm a - dd MMM yy"
    if let date = date {
      return dateFormatter.string(from: date)
    } else {
      return ""
    }
  }
}

#Preview {
  NavigationStack {
    ArticleView(article: sampleArticles[0])
  }
}
