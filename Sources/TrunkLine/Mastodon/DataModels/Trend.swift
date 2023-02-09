// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let [instanceTrend] = try? newJSONDecoder().decode([InstanceTrend].self, from: jsonData)

import Foundation

public extension MastodonServer {
    // MARK: - InstanceTrendElement
    struct TagTrend: Codable {
        public let name: String
        public let url: String
        public let history: [TagTrendHistory]
    }
    
    // MARK: - History
    struct TagTrendHistory: Codable {
        public let day, accounts, uses: String
    }
}
