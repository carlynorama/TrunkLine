// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let instanceMeta = try? newJSONDecoder().decode(InstanceMeta.self, from: jsonData)

import Foundation

public extension MastodonServer {
    // MARK: - InstanceMeta
    struct InstanceProfile: Codable {
        public let uri, title, shortDescription, instanceMetaDescription: String
        public let email, version: String
        public let urls: Dictionary<String,String>//[ServiceURL]?
        public let stats: Stats?  //Dictionary<String,String>
        public let thumbnail: String?
        public let languages: [String]?
        public let registrations, approvalRequired, invitesEnabled: Bool
        public let configuration: Configuration? //Dictionary<String,String>
        public let contactAccount: ContactAccount?
        public let rules: [JSONAny]?
        
        enum CodingKeys: String, CodingKey {
            case uri, title
            case shortDescription = "short_description"
            case instanceMetaDescription = "description"
            case email, version, urls, stats, thumbnail, languages, registrations
            case approvalRequired = "approval_required"
            case invitesEnabled = "invites_enabled"
            case configuration
            case contactAccount = "contact_account"
            case rules
        }
    }
    
    // MARK: - Configuration
    struct Configuration: Codable {
        public let statuses: Statuses
        public let mediaAttachments: MediaAttachments
        public let polls: Polls
        
        enum CodingKeys: String, CodingKey {
            case statuses
            case mediaAttachments = "media_attachments"
            case polls
        }
    }
    
    // MARK: - MediaAttachments
    struct MediaAttachments: Codable {
        public let supportedMIMETypes: [String]
        public let imageSizeLimit, imageMatrixLimit, videoSizeLimit, videoFrameRateLimit: Int
        public let videoMatrixLimit: Int
        
        enum CodingKeys: String, CodingKey {
            case supportedMIMETypes = "supported_mime_types"
            case imageSizeLimit = "image_size_limit"
            case imageMatrixLimit = "image_matrix_limit"
            case videoSizeLimit = "video_size_limit"
            case videoFrameRateLimit = "video_frame_rate_limit"
            case videoMatrixLimit = "video_matrix_limit"
        }
    }
    
    // MARK: - Polls
    struct Polls: Codable {
        public let maxOptions, maxCharactersPerOption, minExpiration, maxExpiration: Int
        
        enum CodingKeys: String, CodingKey {
            case maxOptions = "max_options"
            case maxCharactersPerOption = "max_characters_per_option"
            case minExpiration = "min_expiration"
            case maxExpiration = "max_expiration"
        }
    }
    
    // MARK: - Statuses
    struct Statuses: Codable {
        public let maxCharacters, maxMediaAttachments, charactersReservedPerURL: Int
        
        enum CodingKeys: String, CodingKey {
            case maxCharacters = "max_characters"
            case maxMediaAttachments = "max_media_attachments"
            case charactersReservedPerURL = "characters_reserved_per_url"
        }
    }
    
    // MARK: - ContactAccount
    struct ContactAccount: Codable {
        public let id, username, acct, displayName: String
        public let locked, bot, group: Bool
        public let discoverable: Bool?
        public let createdAt, note: String
        public let url: String
        public let avatar, avatarStatic, header, headerStatic: String
        public let followersCount, followingCount, statusesCount: Int
        public let lastStatusAt: String
        public let emojis, fields: [JSONAny]
        
        enum CodingKeys: String, CodingKey {
            case id, username, acct
            case displayName = "display_name"
            case locked, bot, discoverable, group
            case createdAt = "created_at"
            case note, url, avatar
            case avatarStatic = "avatar_static"
            case header
            case headerStatic = "header_static"
            case followersCount = "followers_count"
            case followingCount = "following_count"
            case statusesCount = "statuses_count"
            case lastStatusAt = "last_status_at"
            case emojis, fields
        }
    }
    
    // MARK: - Stats
    struct Stats: Codable {
        public let userCount, statusCount, domainCount: Int
        
        enum CodingKeys: String, CodingKey {
            case userCount = "user_count"
            case statusCount = "status_count"
            case domainCount = "domain_count"
        }
    }
    
    // MARK: - Urls
    //struct ServiceURL: Codable {
    //    let name:String
    //    let uri:String
    //}
}
