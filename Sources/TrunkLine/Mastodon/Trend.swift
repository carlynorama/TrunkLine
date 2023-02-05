// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let [instanceTrend] = try? newJSONDecoder().decode([InstanceTrend].self, from: jsonData)

import Foundation

extension MastodonAPI {
    // MARK: - InstanceTrendElement
    public struct TagTrend: Codable {
        let name: String
        let url: String
        let history: [TagTrendHistory]
    }
    
    // MARK: - History
    public struct TagTrendHistory: Codable {
        let day, accounts, uses: String
    }
}
