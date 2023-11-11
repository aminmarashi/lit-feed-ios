//
//  ToolbarView.swift
//  feed
//
//  Created by Amin Marashi on 06/11/2023.
//

import SwiftUI

struct ToolbarView: View {
  let feeds: [Feed]
  @Binding var selectedFeed: Feed?
  var body: some View {
    List(feeds, selection: $selectedFeed) { feed in
      NavigationLink(feed.name, value: feed)
    }
    .navigationTitle("Feeds")
    .accessibilityIdentifier("ToolbarView")
  }
}

#Preview {
  NavigationSplitView {
    ToolbarView(feeds: sampleFeeds, selectedFeed: .constant(sampleFeeds[0]))
  } detail: {
    Text("some text")
  }
}
