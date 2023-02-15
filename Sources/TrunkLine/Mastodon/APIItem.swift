////
////  File.swift
////
////
////  Created by Carlyn Maw on 2/7/23.
////
//
import Foundation
import APItizer
//
////How to generate from OpenAPI?
////https://openapi-generator.tech/docs/generators/swift5/
//

//
struct APIItem {
    let versionPath:String
    let endPointPath:String
    
    var fullPath:String {
        "\(versionPath)\(endPointPath)"
    }
    
    public init(versionPath:String = "/v1", endPointPath:String) {
        self.versionPath = versionPath
        self.endPointPath = endPointPath
    }
}


//
//public enum HeaderBuilder {
//    //in this api post, put and delete are all always require auth
//    case get, get_authed, post_urlEncoded, post_multiPart, put, delete, post
//
//    func additionHeaders(
//        auth:Authentication? = nil,
//        additionalHeaders:[String:String] = [:],
//        boundary:String? = nil
//    ) throws-> [String:String] {
//        var headers:[String:String] = [:]
//        for (key, value) in additionalHeaders {
//            headers[key] = value
//        }
//        switch self {
//        case .get:
//            return headers
//        case .get_authed:
//            return try auth!.appendAuthHeader(to: headers)
//        case .post_urlEncoded:
//            headers = try auth!.appendAuthHeader(to: headers)
//            headers["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
//            return headers
//        case .post_multiPart:
//            headers = try auth!.appendAuthHeader(to: headers)
//            headers["Content-Type"] = "multipart/form-data; boundary=\(boundary!)"
//            return headers
//        case .put:
//            headers = try auth!.appendAuthHeader(to: headers)
//            return headers
//        case .delete:
//            headers = try auth!.appendAuthHeader(to: headers)
//            return headers
//        case .post:
//            headers = try auth!.appendAuthHeader(to: headers)
//            return headers
//        }
//    }
//}
//


//
//////https://docs.joinmastodon.org/client/authorized/
////
////Performing actions as the authorized user
////
////With our OAuth token for the authorized user, we can now perform any action as that user that is within our token’s scope.
////
////Publish and delete statuses
////
////See POST /api/v1/statuses for how to create statuses.
////See /api/v1/media for creating media attachments.
////See /api/v1/scheduled_statuses for managing scheduled statuses.
////Interact with timelines
////
////See /api/v1/timelines for accessing timelines.
////See /api/v1/markers for saving and loading positions in timelines.
////See /api/v1/statuses for performing actions on statuses.
////See /api/v1/polls for viewing and voting on polls.
////See /api/v1/lists for obtaining list IDs to use with GET /api/v1/timelines/list/:list_id.
////See /api/v1/conversations for obtaining direct conversations.
////See /api/v1/favourites for listing favourites.
////See /api/v1/bookmarks for listing bookmarks.
////Interact with other users
////
////See /api/v1/accounts for performing actions on other users.
////See /api/v1/follow_requests for handling follow requests.
////See /api/v1/mutes for listing mutes.
////See /api/v1/blocks for listing blocks.
////Receive notifications
////
////See /api/v1/notifications for managing a user’s notifications.
////See /api/v1/push for subscribing to push notifications.
////Discovery features
////
////See /api/v2/search for querying resources.  <- Wait, WAT. /api/v2???
////See /api/v1/suggestions for suggested accounts to follow.
////Use safety features
////
////See /api/v1/filters for managing filtered keywords.
////See /api/v1/domain_blocks for managing blocked domains.
////See /api/v1/reports for creating reports.
////See /api/v1/admin for moderator actions.
////Manage account info
////
////See /api/v1/endorsements for managing a user profile’s featured accounts.
////See /api/v1/featured_tags for managing a user profile’s featured hashtags.
////See /api/v1/preferences for reading user preferences.


    //
    ////TODO: Make a protocol? A struct without all the values set?
    //public struct MastodonVersion1:MastodonAPIVersion {
    //    let version = "1.1.1"
    //    let urlString:String = "/api/v1"
    //    //    var description:String = "v1"
    //
    //    let endpointPaths:Dictionary<String, APICall> = [
    //        "instance" : "/instance",
    //        "trends" : "/trends",
    //
    //        "public_timeline" : "/timelines/public",
    //        "tag_timeline" : "/timelines/tag/{tag}",
    //
    //        "id" : "/users/{handle}",
    //        // use with /accounts/
    //        "account_by_id" : "{id_string}",
    //        "verify" : "/apps/verify_credentials",
    //        "verify_account" : "/accounts/verify_credentials", //=> Account
    //        // use with /account/
    //        "following" : "{id_string}/following",
    //        "followers" : "{id_string}/followers",
    //        "liked" : "{id_string}/liked",
    //        "inbox" : "{id_string}/inbox",
    //        "outbox" : "{id_string}/outbox",
    //        "statuses" : "{id_string}/statuses",
    //        // use with /statuses/
    //        "translate" : "/statuses/{id_string}/translate", //POST
    //        "new_status" : "/statuses/",  //POST
    //        "status_by_id" : "/statuses/{id_string}", //GET
    //        "edit_status" : "statuses/{id_string}",   //PUT
    //        "delete" : "/statuses/{id_string}", //DELETE.
    //        "thread_context" : "/statuses/{id_string}/context",
    //        "reblogged_by" : "/statuses/{id_string}/reblogged_by",  //can use TimelineConfigurationShort
    //        "favourited_by" : "/statuses/{id_string}/favourited_by", //can use TimelineConfigurationShort
    //        "favourite" : "/statuses/{id_string}/favourite",
    //        "unfavourite": "/statuses/{id_string}/unfavourite",
    //        "boost": "/statuses/{id_string}/reblog",
    //        "unboost" : "/statuses/{id_string}/unreblog",
    //        "bookmark" : "/statuses/{id_string}/bookmark",
    //        "unbookmark" : "/statuses/{id_string}/unbookmark",
    //        "mute": "/statuses/{id_string}/mute",
    //        "unmute" : "/statuses/{id_string}/unmute",
    //        "pin" : "/statuses/{id_string}/pin",
    //        "unpin" : "/statuses/{id_string}/unpin",
    //        "history" : "/statuses/{id_string}/history",
    //        "source" : "/statuses/{id_string}/source" //for editing
    //    ]
    //}
