//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation
import APItizer


extension MastodonServer {
    
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
    
    public struct TimelineConfigurationShort: QueryEncodable {
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
    
    public struct StatusConfiguration:URLEncodable {
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
        
        public func makeURLEncodedString() throws -> String {
            var queries:[URLQueryItem] = []
            
            let dictionary = DictionaryEncoder.makeDictionary(fromEncodable: self)
            
            for (key, value) in dictionary {
                if key != "media_ids" {
                    queries.append(URLQueryItem(name: key, value: value))
                } else {
                    queries.append(contentsOf: QueryEncoder.arrayToQueryItems(baseStringForKey: "media_ids", array: self.media_ids!))
                }
            }
            
            return try URLEncoder.makeURLEncodedString(queryItems: queries)
            
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
    
    struct MediaAttachmentCofiguration:MultiPartFormEncodeable {
        let file:Attachable //REQUIRED Object. The file to be attached, encoded using multipart form data. The file must have a MIME type.
        let thumbnail:Attachable? //Object. The custom thumbnail of the media to be attached, encoded using multipart form data.
        let description:String //String. A plain-text description of the media, for accessibility purposes.
        let focus_x:Double?
        let focus_y:Double? //String. Two floating points (x,y), comma-delimited, ranging from -1.0 to 1.0. See Focal points for cropping media thumbnails for more information.
        
        func makeFormBody(withTermination: Bool) throws -> (boundary: String, body: Data) {
            var stringItems:Dictionary<String, CustomStringConvertible> = [
                "description":description
            ]
            if !(focus_x == nil && focus_y == nil) {
                stringItems["focus"]="\(focus_x ?? 0.5),\(focus_y ?? 0.5)"
            }
            
            var attachments:[String:Attachable] = [
                "file":file
            ]
            if let thumbnail {
                attachments["thumbnail"]=thumbnail
            }
        
            
            return try MultiPartFormEncoder.makeBodyData(stringItems:stringItems, attachments:attachments, withTermination:withTermination)
        }
        
    }
    
    
    
}
