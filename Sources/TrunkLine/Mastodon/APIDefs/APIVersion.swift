//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer

//How to generate from OpenAPI?
//https://openapi-generator.tech/docs/generators/swift5/

//TODO: Make a protocol? A struct without all the values set?
public struct APIVersion {
    let version = "1.1.1"
    let urlString:String = "/api/v1"
    var description:String = "v1"
    
    let endpointPaths:Dictionary<String, String> = [
        "instance" : "/instance",
        "trends" : "/trends",
        
        "public_timeline" : "/timelines/public",
        "tag_timeline" : "/timelines/tag/{tag}",
        
        "id" : "/users/{handle}",
        // use with /accounts/
        "account_by_id" : "{id_string}",
        "verify" : "/apps/verify_credentials",
        "verify_account" : "/accounts/verify_credentials", //=> Account
        // use with /account/
        "following" : "{id_string}/following",
        "followers" : "{id_string}/followers",
        "liked" : "{id_string}/liked",
        "inbox" : "{id_string}/inbox",
        "outbox" : "{id_string}/outbox",
        "statuses" : "{id_string}/statuses",
        // use with /statuses/
        "translate" : "/statuses/{id_string}/translate", //POST
        "new_status" : "/statuses/",  //POST
        "status_by_id" : "/statuses/{id_string}", //GET
        "edit_status" : "statuses/{id_string}",   //PUT
        "delete" : "/statuses/{id_string}", //DELETE.
        "thread_context" : "/statuses/{id_string}/context",
        "reblogged_by" : "/statuses/{id_string}/reblogged_by",  //can use TimelineConfigurationShort
        "favourited_by" : "/statuses/{id_string}/favourited_by", //can use TimelineConfigurationShort
        "favourite" : "/statuses/{id_string}/favourite",
        "unfavourite": "/statuses/{id_string}/unfavourite",
        "boost": "/statuses/{id_string}/reblog",
        "unboost" : "/statuses/{id_string}/unreblog",
        "bookmark" : "/statuses/{id_string}/bookmark",
        "unbookmark" : "/statuses/{id_string}/unbookmark",
        "mute": "/statuses/{id_string}/mute",
        "unmute" : "/statuses/{id_string}/unmute",
        "pin" : "/statuses/{id_string}/pin",
        "unpin" : "/statuses/{id_string}/unpin",
        "history" : "/statuses/{id_string}/history",
        "source" : "/statuses/{id_string}/source" //for editing
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
    
    struct TimelineConfigurationShort: QueryEncodable {
        let max_id:String? //String. Return results older than ID.
        let since_id:String? //String. Return results newer than ID.
        let min_id:String? //String. Return results immediately newer than ID.
        let limit:Int?
        
        public init(local: Bool? = nil, remote: Bool? = nil, only_media: Bool? = nil, max_id: String? = nil, since_id: String? = nil, min_id: String? = nil, limit: Int? = nil) {
            self.max_id = max_id
            self.since_id = since_id
            self.min_id = min_id
            self.limit = limit
        }
    }
    
    struct StatusConfiguration:QueryEncodable {
//        //Headers
//        let authheaderRequired = true
//        let method:HTTPRequestService.Method = .post
//        let idempotency:String?
        //Idempotency-Key
        //Provide this header with any arbitrary string to prevent duplicate submissions of the same status. Consider using a hash or UUID generated client-side. Idempotency keys are stored for up to 1 hour.
 
        //REQUIRED String. The text content of the status. If media_ids is provided, this becomes optional. Attaching a poll is optional while status is provided.
        let status:String?
        
        //REQUIRED Array of String. Include Attachment IDs to be attached as media. If provided, status becomes optional, and poll cannot be used.
        let media_ids:[String]?
        
        //String. ID of the status being replied to, if status is a reply.
        let in_reply_to_id:String?
        //Boolean. Mark status and attached media as sensitive? Defaults to false.
        let sensitive: Bool?
        
        //String. Text to be shown as a warning or subject before the actual content. Statuses are generally collapsed behind this field.
        let spoiler_text:String?
        
        //String. Sets the visibility of the posted status to public, unlisted, private, direct.
        let visibility:String?

        //String. ISO 639 language code for this status.
        let language:String?
        
        //String. ISO 8601 Datetime at which to schedule a status. Providing this parameter will cause ScheduledStatus to be returned instead of Status. Must be at least 5 minutes in the future.
        let scheduled_at:String?
        
        public init(status: String? = nil, media_ids: [String]? = nil, in_reply_to_id: String? = nil, sensitive: Bool? = nil, spoiler_text: String? = nil, visibility: MastodonServer.Visibility? = nil, language: String? = nil, scheduled_at: Date? = nil) throws {
            if !(!(status?.isEmpty ?? true) || !(media_ids?.isEmpty ?? true) ) {
                throw MastodonAPIError("either status or media_ids must contain content.")
            }
            self.status = status
            self.media_ids = media_ids
            self.in_reply_to_id = in_reply_to_id
            self.sensitive = sensitive
            self.spoiler_text = spoiler_text
            self.visibility = visibility?.rawValue
            self.language = language
            self.scheduled_at = scheduled_at?.ISO8601Format()
        }
        

        
        //poll[options][]
        //REQUIRED Array of String. Possible answers to the poll. If provided, media_ids cannot be used, and poll[expires_in] must be provided.
        //poll[expires_in]
        //REQUIRED Integer. Duration that the poll should be open, in seconds. If provided, media_ids cannot be used, and poll[options] must be provided.
        //poll[multiple]
        //Boolean. Allow multiple choices? Defaults to false.
        //poll[hide_totals]
        //Boolean. Hide vote counts until the poll ends? Defaults to false.
        
    }
    
    
    
}

////https://docs.joinmastodon.org/client/authorized/
//
//Performing actions as the authorized user
//
//With our OAuth token for the authorized user, we can now perform any action as that user that is within our token’s scope.
//
//Publish and delete statuses
//
//See POST /api/v1/statuses for how to create statuses.
//See /api/v1/media for creating media attachments.
//See /api/v1/scheduled_statuses for managing scheduled statuses.
//Interact with timelines
//
//See /api/v1/timelines for accessing timelines.
//See /api/v1/markers for saving and loading positions in timelines.
//See /api/v1/statuses for performing actions on statuses.
//See /api/v1/polls for viewing and voting on polls.
//See /api/v1/lists for obtaining list IDs to use with GET /api/v1/timelines/list/:list_id.
//See /api/v1/conversations for obtaining direct conversations.
//See /api/v1/favourites for listing favourites.
//See /api/v1/bookmarks for listing bookmarks.
//Interact with other users
//
//See /api/v1/accounts for performing actions on other users.
//See /api/v1/follow_requests for handling follow requests.
//See /api/v1/mutes for listing mutes.
//See /api/v1/blocks for listing blocks.
//Receive notifications
//
//See /api/v1/notifications for managing a user’s notifications.
//See /api/v1/push for subscribing to push notifications.
//Discovery features
//
//See /api/v2/search for querying resources.  <- Wait, WAT. /api/v2???
//See /api/v1/suggestions for suggested accounts to follow.
//Use safety features
//
//See /api/v1/filters for managing filtered keywords.
//See /api/v1/domain_blocks for managing blocked domains.
//See /api/v1/reports for creating reports.
//See /api/v1/admin for moderator actions.
//Manage account info
//
//See /api/v1/endorsements for managing a user profile’s featured accounts.
//See /api/v1/featured_tags for managing a user profile’s featured hashtags.
//See /api/v1/preferences for reading user preferences.
