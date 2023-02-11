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
    //public private(set) var apiversion = APIVersion()
    public private(set) var authentication: Authentication?
    
    
    public var version: String? {
        "Mixing v1 and v2"
    }
    
    public var apiBase: String? {
        "/api"
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
        let path = actions["verify"]!.fullPath
        let url = try? urlFrom(path: path, usingAPIBase: true)
        let header = try authentication.appendAuthHeader(to:[:])
        //TODO: BAD - I'm pointing at a RequestService implmentation.
        let request =  HTTPRequestService.buildRequest(for: url!, with: header)!
        let (data, _) = try await URLSession.shared.data(for: request)
        return data
    }
    
    let actions:Dictionary<String, APIPath> = [
        "instance" : APIPath(endPointPath:"/instance"),
        "trends" : APIPath(endPointPath:"/trends"),
        
        "public_timeline" : APIPath(endPointPath:"/timelines/public"),
        "tag_timeline" : APIPath(endPointPath:"/timelines/tag/{tag}"),
        
        "id" : APIPath(endPointPath:"/users/{handle}"),
        // use with /accounts/
        "account_by_id" : APIPath(endPointPath:"{id_string}"),
        "verify" : APIPath(endPointPath:"/apps/verify_credentials"),
        "verify_account" : APIPath(endPointPath:"/accounts/verify_credentials"), //=> Account
        // use with /account/
        "following" : APIPath(endPointPath:"{id_string}/following"),
        "followers" : APIPath(endPointPath:"{id_string}/followers"),
        "liked" : APIPath(endPointPath:"{id_string}/liked"),
        "inbox" : APIPath(endPointPath:"{id_string}/inbox"),
        "outbox" : APIPath(endPointPath:"{id_string}/outbox"),
        "statuses" : APIPath(endPointPath:"{id_string}/statuses"),
        // use with /statuses/
        "translate" : APIPath(endPointPath:"/statuses/{id_string}/translate"), //POST
        "new_status" : APIPath(endPointPath:"/statuses/"),  //POST, form or urlencoded
        "status_by_id" : APIPath(endPointPath:"/statuses/{id_string}"), //GET
        "edit_status" : APIPath(endPointPath:"statuses/{id_string}"),   //PUT
        "delete" : APIPath(endPointPath:"/statuses/{id_string}"), //DELETE
        "thread_context" : APIPath(endPointPath:"/statuses/{id_string}/context"),
        "reblogged_by" : APIPath(endPointPath:"/statuses/{id_string}/reblogged_by"),  //can use TimelineConfigurationShort
        "favourited_by" : APIPath(endPointPath:"/statuses/{id_string}/favourited_by"), //can use TimelineConfigurationShort
        "favourite" : APIPath(endPointPath:"/statuses/{id_string}/favourite"),
        "unfavourite": APIPath(endPointPath:"/statuses/{id_string}/unfavourite"),
        "boost": APIPath(endPointPath:"/statuses/{id_string}/reblog"),
        "unboost" : APIPath(endPointPath:"/statuses/{id_string}/unreblog"),
        "bookmark" : APIPath(endPointPath:"/statuses/{id_string}/bookmark"),
        "unbookmark" : APIPath(endPointPath:"/statuses/{id_string}/unbookmark"),
        "mute": APIPath(endPointPath:"/statuses/{id_string}/mute"),
        "unmute" : APIPath(endPointPath:"/statuses/{id_string}/unmute"),
        "pin" : APIPath(endPointPath:"/statuses/{id_string}/pin"),
        "unpin" : APIPath(endPointPath:"/statuses/{id_string}/unpin"),
        "history" : APIPath(endPointPath:"/statuses/{id_string}/history"),
        "source" : APIPath(endPointPath:"/statuses/{id_string}/source"),//for editin)g
        //media
        "upload_media" : APIPath(versionPath: "/v2", endPointPath: "/media") //POST, Form
    ]
}




