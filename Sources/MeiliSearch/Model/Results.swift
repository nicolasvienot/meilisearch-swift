import Foundation
#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

/**
 `Results` is a wrapper used in multiple routes returning an array of data.
 */

public struct Results<T: Decodable & Encodable & Equatable>: Codable, Equatable {
  public let results: [T]
}
