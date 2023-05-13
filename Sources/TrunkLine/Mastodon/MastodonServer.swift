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

public struct MastodonServer:APIService, Authorizable {
    public private(set)var serverScheme: URIScheme
    public var requestService: RequestService
    //this is a temp fix until gett SSE working
    #if !os(Linux)
    var streamService: SSEListener?
    #endif
    public private(set) var serverHost: URL
    public var serverPort: Int? = nil
    //public private(set) var apiversion = APIVersion()
    public private(set) var authentication: Authentication?
    
    
    public var defaultVersionBase: String? {
        "/v1"
    }
    
    public var defaultAPIBase: String? {
        "/api"
    }
    
    public init(host:URL, scheme:URIScheme = .https) {
        self.serverHost =  host
        self.serverScheme = scheme
        self.requestService = scheme.reccomendedRequestService
        self.authentication = nil
    }
    
    public var hasValidToken: Bool {
        //not exactly true.
        authentication != nil && authentication!.hasStoredToken
    }
    
    //STEPONE - does the keychain still work.
    public mutating func authorize(_ auth:Authentication) {
        authentication = auth
    }

    #if !os(Linux)
    //account: "TrunkLineLib_tipsyrobot", service: "access-token", keyBase: ""
    public mutating func tryAuthFromKeychain(account:String, service:String, keyBase:String) throws {
        let auth = try TrunkLine.fetchAuthFromKeychain(account: account, service: service, keyBase: keyBase)
        if auth.hasStoredToken {
            authorize(auth)
            //print("saved auth")
            //print(self.hasValidToken)
        } else {
            throw MastodonAPIError("Could find in keychain, did not save to the environment")
        }
        //print(self)
        
    }
    #endif
    
    public func checkCredential() async throws -> Data {
        let path = actions["verify"]!.endPointPath
        let url = try urlFrom(path: path, prependBasePath: true)
        //print(url.absoluteString)
        return try await fetchData(from:url, withAuth:true)
    }
    
    let actions:Dictionary<String, APIItem> = [
        "instance" : APIItem(endPointPath:"/instance"),
        "trends" : APIItem(endPointPath:"/trends"),
        
        "public_timeline" : APIItem(endPointPath:"/timelines/public"),
        "tag_timeline" : APIItem(endPointPath:"/timelines/tag/{tag}"),
        
        "id" : APIItem(endPointPath:"/users/{handle}"),
        // use with /accounts/
        "account_by_id" : APIItem(endPointPath:"{id_string}"),
        "verify" : APIItem(endPointPath:"/apps/verify_credentials"),
        "verify_account" : APIItem(endPointPath:"/accounts/verify_credentials"), //=> Account
        // use with /account/
        "following" : APIItem(endPointPath:"{id_string}/following"),
        "followers" : APIItem(endPointPath:"{id_string}/followers"),
        "liked" : APIItem(endPointPath:"{id_string}/liked"),
        "inbox" : APIItem(endPointPath:"{id_string}/inbox"),
        "outbox" : APIItem(endPointPath:"{id_string}/outbox"),
        "statuses" : APIItem(endPointPath:"{id_string}/statuses"),
        // use with /statuses/
        "translate" : APIItem(endPointPath:"/statuses/{id_string}/translate"), //POST
        "new_status" : APIItem(endPointPath:"/statuses/"),  //POST, form or urlencoded
        "status_by_id" : APIItem(endPointPath:"/statuses/{id_string}"), //GET
        "edit_status" : APIItem(endPointPath:"statuses/{id_string}"),   //PUT
        "delete" : APIItem(endPointPath:"/statuses/{id_string}"), //DELETE
        "thread_context" : APIItem(endPointPath:"/statuses/{id_string}/context"),
        "reblogged_by" : APIItem(endPointPath:"/statuses/{id_string}/reblogged_by"),  //can use TimelineConfigurationShort
        "favourited_by" : APIItem(endPointPath:"/statuses/{id_string}/favourited_by"), //can use TimelineConfigurationShort
        "favourite" : APIItem(endPointPath:"/statuses/{id_string}/favourite"),
        "unfavourite": APIItem(endPointPath:"/statuses/{id_string}/unfavourite"),
        "boost": APIItem(endPointPath:"/statuses/{id_string}/reblog"),
        "unboost" : APIItem(endPointPath:"/statuses/{id_string}/unreblog"),
        "bookmark" : APIItem(endPointPath:"/statuses/{id_string}/bookmark"),
        "unbookmark" : APIItem(endPointPath:"/statuses/{id_string}/unbookmark"),
        "mute": APIItem(endPointPath:"/statuses/{id_string}/mute"),
        "unmute" : APIItem(endPointPath:"/statuses/{id_string}/unmute"),
        "pin" : APIItem(endPointPath:"/statuses/{id_string}/pin"),
        "unpin" : APIItem(endPointPath:"/statuses/{id_string}/unpin"),
        "history" : APIItem(endPointPath:"/statuses/{id_string}/history"),
        "source" : APIItem(endPointPath:"/statuses/{id_string}/source"),//for editin)g
        //media
        "upload_media" : APIItem(versionPath: "/v2", endPointPath: "/media") //POST, Form
    ]
}




