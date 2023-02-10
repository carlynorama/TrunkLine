//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation
import APItizer

enum MastodonAPIError: Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    init(_ message: String) {
        self = .message(message)
    }
}

//apiBase: "/api/v1"
public struct MastodonServer:APIServer, Authorizable {
    
    public private(set)var scheme: Scheme
    public private(set) var host: URL
    public private(set) var apiversion = APIVersion()
    public private(set) var authentication: Authentication?
    
    
    public var version: String? {
        apiversion.description
    }
    
    public var apiBase: String? {
        apiversion.urlString
    }
    
    public init(host:URL, scheme:Scheme = .https) {
        self.host =  host
        self.scheme = scheme
        self.authentication = nil
    }
    
    public var hasValidToken: Bool {
        //not exactly true.
        authentication != nil
    }
    
    //STEPONE - does the keychain still work.
    public mutating func authorize(_ auth:Authentication) throws {
        authentication = auth
    }
    
    public func checkCredential(authentication:Authentication) async throws -> Data {
        let path = apiversion.endpointPaths["verify"]
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        let header = try authentication.appendAuthHeader(to:[:])
        //TODO: BAD - I'm pointing at a RequestService implmentation.
        let request =  HTTPRequestService.buildRequest(for: url!, with: header)!
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
}


