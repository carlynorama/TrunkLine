//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer

public struct APIVersion {
    let version = "1.1.1"
    let urlString:String = "/api/v1"
    var description:String = "v1"
    
    let publicDataEndpointPaths:Dictionary<String, String> = [
        "instance" : "/instance",
        "trends" : "/trends",
        "public_timeline" : "/timelines/public",
        "tag_timeline" : "/timelines/tag/{tag}",
        
        "id" : "/users/{handle}",
        // /accounts/
        "account_by_id" : "{id_string}",
        // /account/
        "following" : "{id_string}/following",
        "followers" : "{id_string}/followers",
        "liked" : "{id_string}/liked",
        "inbox" : "{id_string}/inbox",
        "outbox" : "{id_string}/outbox",
        "statuses" : "{id_string}/statuses"
        // /statuses/
    ]
    
    struct TimelineConfiguration: QueryEncodable {
        let local:Bool? //Boolean. Show only local statuses? Defaults to false.
        let remote:Bool? //Boolean. Show only remote statuses? Defaults to false.
        let only_media:Bool? //Boolean. Show only statuses with media attached? Defaults to false.
        let max_id:String? //String. Return results older than ID.
        let since_id:String? //String. Return results newer than ID.
        let min_id:String? //String. Return results immediately newer than ID.
        let limit:Int?
        
        public init(local: Bool? = nil, remote: Bool? = nil, only_media: Bool? = nil, max_id: String? = nil, since_id: String? = nil, min_id: String? = nil, limit: Int? = nil) {
            self.local = local
            self.remote = remote
            self.only_media = only_media
            self.max_id = max_id
            self.since_id = since_id
            self.min_id = min_id
            self.limit = limit
        }
    }
    
    
}
