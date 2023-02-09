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
        self._token = readTokenFromKeyChain(accountKey:"tipsyrobot")
    }
    
    //AUTHORIZABLE
    //TODO: Property Wrapper for token?
    //TODO: /accounts/update_credentials
     
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
    
    public var serviceKey: String = "access-token"
    public var accountKeyBase: String = "TrunkLineLib"
    
    public func checkCredential(token:String) async throws -> Data {
        let path = apiversion.endpointPaths["verify"]
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        let header = appendAuthHeader(to:[:], token:token)
        //TODO: BAD - I'm pointing at a RequestService implmentation.
        let request =  HTTPRequestService.buildRequest(for: url!, with: header)!
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    //"tipsyrobot"
    mutating public func loadTokenFromKeyChain(for account:String) {
        let readToken = readTokenFromKeyChain(accountKey: account)
        _token = readToken // if setter saves to keychain can't user setter here.
        //TODO: should verify be part of the loading?
//        do {
//            let data = try await checkCredential(token: accessTokenOut)
//            print(String(data: data, encoding: .utf8)!)
//        } catch {
//            print(error)
//        }
    }
    
}
    
    
