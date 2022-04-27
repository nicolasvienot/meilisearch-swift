@testable import MeiliSearch
import XCTest
import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

// swiftlint:disable force_try
class DumpsTests: XCTestCase {
  private var client: MeiliSearch!
  private var session: URLSessionProtocol!
  private let uid: String = "books_test"

  // MARK: Setup

  override func setUp() {
    super.setUp()
    if client == nil {
      session = URLSession(configuration: .ephemeral)
      client = try! MeiliSearch(host: "http://localhost:7700", apiKey: "masterKey", session: session)
    }
  }

  func testCreateAndGetDump() {
    let expectation = XCTestExpectation(description: "Request dump status")

    self.client.createDump { result in
      switch result {
      case .success(let createDump):
        XCTAssertTrue(!createDump.uid.isEmpty)
        self.client.getDumpStatus(createDump.uid) { result in
          switch result {
          case .success(let dumpStatus):
            XCTAssertEqual(createDump.uid, dumpStatus.uid)
          case .failure(let error):
            XCTFail("Failed to request dump status \(error)")
          }
          expectation.fulfill()
        }
      case .failure(let error):
        dump(error)
        XCTFail("Failed to request dump creation \(error)")
        expectation.fulfill()
      }
    }

    self.wait(for: [expectation], timeout: TESTS_TIME_OUT)
  }
}
// swiftlint:enable force_try
