//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation
import APItizer

public enum MastodonAPIError: Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    fileprivate init(_ message: String) {
        self = .message(message)
    }
}

//apiBase: "/api/v1"
public struct MastodonServer:APIServer {
    
    
    public private(set)var scheme: Scheme
    public private(set) var host: URL
    public private(set) var apiversion: APIVersion
    
    
    
    public var version: String? {
        apiversion.description
    }
    
    public var apiBase: String? {
        apiversion.urlString
    }
    
    
    public enum APIVersion {
        case v1
        
        var urlString:String {
            "/api/v1"
        }
        
        var description:String {
            "v1"
        }
    }
    
    public init(host:URL, version:APIVersion, scheme:Scheme = .https) {
        self.host =  host
        self.apiversion =  version
        self.scheme = scheme
        self._token = nil
    }
    
    
    
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
    
}
    
    
