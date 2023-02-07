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
    
    public var version: String? {
        apiversion.description
    }
    
    public var apiBase: String? {
        apiversion.urlString
    }
    
    public init(host:URL, scheme:Scheme = .https) {
        self.host =  host
        self.scheme = scheme
        self._token = nil
    }
    
   // let verifyCredentials = "accounts/verify_credentials"
    //TODO: /accounts/update_credentials
    
    
    //AUTHORIZABLE
    public var token: String? {
        _token
    }
    
    private var _token:String?
    
    mutating public func setToken(token: String) {
        //TODO: confirm with server
        _token = token
    }
    
    mutating public func clearToken() {
        _token = nil
    }
    
    public var isAuthorized: Bool {
        _token != nil
    }
    
    
    public func checkCredential(token:String) {
//        curl \
//            -H 'Authorization: Bearer our_access_token_here' \
//            https://mastodon.example/api/v1/apps/verify_credentials
        let path = apiversion.publicDataEndpointPaths["verify"]
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        print(url!.absoluteString)
        let header = appendOAuthHeader(to:[:], token:token)
        
        
    }
    
    
    
}
    
    
