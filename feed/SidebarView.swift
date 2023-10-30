//
//  SidebarView.swift
//  feed
//
//  Created by Amin Marashi on 31/10/2023.
//

import SwiftUI

struct SidebarView: View {
  var body: some View {
    NavigationView {
      VStack(alignment: .leading) {
        Button(action: {
        }) {
          HStack {
            Image(systemName: "chevron.left")
              .font(.system(size: 20))
              .foregroundColor(.primary)
            Text("Articles")
              .font(.headline)
              .foregroundColor(.primary)
          }
          .padding(.vertical, 10)
          .padding(.horizontal, 20)
        }
        List {
          Text("Feed 1")
          Text("Feed 2")
          Text("Feed 3")
          Text("Feed 4")
          Text("Feed 5")
          Text("Feed 6")
          Text("Feed 7")
          Text("Feed 8")
          Text("Feed 9")
        }
        .listStyle(SidebarListStyle())
      }
      .frame(maxWidth: .infinity, alignment: .leading)
      .navigationBarHidden(true)
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .edgesIgnoringSafeArea(.all)
  }
}

#Preview {
    SidebarView()
}
