//
//  feedUITests.swift
//  feedUITests
//
//  Created by Amin Marashi on 27/10/2023.
//

import XCTest

final class feedUITests: XCTestCase {
  override func setUpWithError() throws {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    // Set orientation to portrait
    XCUIDevice.shared.orientation = .portrait
  }

  override func tearDownWithError() throws {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
  }

  func testNavigation() throws {
    // UI tests must launch the application that they test.
    let app = XCUIApplication()
    app.launch()

    // Use XCTAssert and related functions to verify your tests produce the correct results.

    // Find a button with "All Articles" text and tap it
    let allArticlesButton = app.buttons["All Articles"]
    allArticlesButton.tap()

    // Make sure the FeedView view is showing
    let feedView = app.navigationBars["All Articles"]
    XCTAssertTrue(feedView.exists)

    // Click on the first article in the list
    let firstArticle = app.buttons["Article 1 Title"]
    XCTAssert(firstArticle.exists)
    firstArticle.tap()

    // Make sure the ArticleView view is showing
    let articleView = app.navigationBars["Article 1 Title"]
    XCTAssertTrue(articleView.exists)

    // Go back to the FeedView view
    app.navigationBars.buttons.element(boundBy: 0).tap()

    // Make sure the FeedView view is showing
    XCTAssertTrue(feedView.exists)

    // Go back to the ContentView view
    app.navigationBars.buttons.element(boundBy: 0).tap()

    // Make sure the ContentView view is showing
    let contentView = app.navigationBars["Feeds"]
    XCTAssertTrue(contentView.exists)
  }

  func testLaunchPerformance() throws {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
      // This measures how long it takes to launch your application.
      measure(metrics: [XCTApplicationLaunchMetric()]) {
        XCUIApplication().launch()
      }
    }
  }
}
