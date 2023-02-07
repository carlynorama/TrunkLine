//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation



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
    
    struct TimelineConfiguration {
        let local:Bool? //Boolean. Show only local statuses? Defaults to false.
        let remote:Bool? //Boolean. Show only remote statuses? Defaults to false.
        let only_media:Bool? //Boolean. Show only statuses with media attached? Defaults to false.
        let max_id:String? //String. Return results older than ID.
        let since_id:String? //String. Return results newer than ID.
        let min_id:String? //String. Return results immediately newer than ID.
        let limit:Int?
    }
    
    
}
