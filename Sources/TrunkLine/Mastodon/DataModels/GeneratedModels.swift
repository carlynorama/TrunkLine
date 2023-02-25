// This file was generated from JSON Schema using quicktype, do not modify it directly.

//TO AUDIENCE: This was modified to make more things optional and remove JSONNULL references for now

// To parse the JSON, add this file to your project and do:
//
//   let mastodonStatusItem = try? newJSONDecoder().decode(MastodonStatusItem.self, from: jsonData)

import Foundation

public extension MastodonServer {
    
    // MARK: - MastodonStatusItem
    struct StatusItem: Codable, Identifiable, Equatable, Hashable {
        public static func debugDecoder(_ string:String) {
            _ = string.data(using: .utf8)!.verboseDecode(ofType: Self.self)
            print("----------------------------------")
            print(string)
            print("----------------------------------")
        }
        
        public static func == (lhs: MastodonServer.StatusItem, rhs: MastodonServer.StatusItem) -> Bool {
            lhs.hashValue == rhs.hashValue
        }
        
        public func hash(into hasher: inout Hasher) {
            hasher.combine(id)
            hasher.combine(content)
        }
        
        //Appears to be always
        public let id, createdAt: String
        public let account: Account
        public let content: String
        public let sensitive: Bool
        public let spoilerText: String
        public let visibility: Visibility  //check Visibility
        public let repliesCount, reblogsCount, favouritesCount: Int
        public let uri, url: String
        
        //Appears to be optional
        public let language: String?
        public let inReplyToID, inReplyToAccountID: String?  //vs JSONNull
        public let favourited, reblogged, muted, bookmarked: Bool?
        public let reblog: String?
        public let application: Application?
        public let mediaAttachments: [ItemMediaAttachment]?
        public let mentions, emojis: [JSONAny]?
        public let tags: [Tag]?
        public let card: Card?
        public let poll: Poll?
        
        enum CodingKeys: String, CodingKey {
            case id
            case createdAt = "created_at"
            case inReplyToID = "in_reply_to_id"
            case inReplyToAccountID = "in_reply_to_account_id"
            case sensitive
            case spoilerText = "spoiler_text"
            case visibility, language, uri, url
            case repliesCount = "replies_count"
            case reblogsCount = "reblogs_count"
            case favouritesCount = "favourites_count"
            case favourited, reblogged, muted, bookmarked, content, reblog, application, account
            case mediaAttachments = "media_attachments"
            case mentions, tags, emojis, card
            case poll
        }
    }
    
    enum Visibility: String, Codable {
        case direct = "direct"
        case priv = "private"
        case unlisted = "unlisted"
        case pub = "public"
    }
    
    // MARK: - Account
    struct Account: Codable, Identifiable {
        public let id, username, acct, displayName: String
        public let locked, bot, group: Bool
        public let discoverable: Bool?
        public let createdAt, note: String
        public let url: String
        public let avatar, avatarStatic: String
        public let header, headerStatic: String
        public let followersCount, followingCount, statusesCount: Int
        public let lastStatusAt: String
        public let emojis: [JSONAny]
        public let fields: [Field]
        
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
    
    // MARK: - Field
    struct Field: Codable {
        let name, value: String
        let verifiedAt: String?
        
        enum CodingKeys: String, CodingKey {
            case name, value
            case verifiedAt = "verified_at"
        }
    }
    
    // MARK: - Application
    struct Application: Codable {
        let name: String
        let website: String?
    }
    
    // MARK: - Card
    struct Card: Codable {
        public let url: String
        public let title, cardDescription, type, authorName: String
        public let authorURL, providerName, providerURL, html: String
        public let width, height: Int
        public let image: String?
        public let embedURL: String
        
        enum CodingKeys: String, CodingKey {
            case url, title
            case cardDescription = "description"
            case type
            case authorName = "author_name"
            case authorURL = "author_url"
            case providerName = "provider_name"
            case providerURL = "provider_url"
            case html, width, height, image
            case embedURL = "embed_url"
        }
    }
    
    // MARK: - MediaAttachments
    typealias AttachmentArray = [ItemMediaAttachment]
    struct ItemMediaAttachments: Codable {
        public let attachments: AttachmentArray
        
        enum CodingKeys: String, CodingKey {
            case attachments = "media_attachments"
        }
    }
    

    
    // MARK: - MediaAttachment
    struct ItemMediaAttachment: Codable,Identifiable {
        public let id, type: String
        public let url, previewURL: String
        public let remoteURL, previewRemoteURL, textURL: String?
        public let meta: MastodonServer.MediaMeta?
        public let mediaAttachmentDescription, blurhash: String?
        
        enum CodingKeys: String, CodingKey {
            case id, type, url
            case previewURL = "preview_url"
            case remoteURL = "remote_url"
            case previewRemoteURL = "preview_remote_url"
            case textURL = "text_url"
            case meta
            case mediaAttachmentDescription = "description"
            case blurhash
        }
    }
    
    // MARK: - MediaMeta
    struct MediaMeta: Codable {
        public let original, small: MediaDimensions?
        public let focus:MediaFocus?
    }
    
    // MARK: - Dimensions
    struct MediaDimensions: Codable {
        public let width, height: Int?
        public let size: String?
        public let aspect: Double?
    }
    
    struct MediaFocus: Codable {
        public let x:Double
        public let y:Double
    }
    
    // MARK: - Poll
    struct Poll: Codable {
        public let id, expiresAt: String
        public let expired, multiple: Bool
        public let votesCount, votersCount: Int?
        public let options: [PollOption]
        
        enum CodingKeys: String, CodingKey {
            case id
            case expiresAt = "expires_at"
            case expired, multiple
            case votesCount = "votes_count"
            case votersCount = "voters_count"
            case options
        }
    }
    
    // MARK: - PollOption
    struct PollOption: Codable {
        public let title: String
        public let votesCount: Int
        
        enum CodingKeys: String, CodingKey {
            case title
            case votesCount = "votes_count"
        }
    }
    
    //MARK: Tag
    struct Tag: Codable {
        let name: String
        let url: String
    }
    
    // MARK: - Encode/decode helpers
    
    class JSONNull: Codable, Hashable {
        
        public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
            return true
        }
        
        //https://stackoverflow.com/questions/55395207/swift-hashable-hashvalue-is-deprecated-as-a-protocol-requirement
        public func hash(into hasher: inout Hasher) {
            hasher.combine(0)
        }
        
        public init() {}
        
        public required init(from decoder: Decoder) throws {
            let container = try decoder.singleValueContainer()
            if !container.decodeNil() {
                throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
    
    class JSONCodingKey: CodingKey {
        let key: String
        
        required public init?(intValue: Int) {
            return nil
        }
        
        required public init?(stringValue: String) {
            key = stringValue
        }
        
        public var intValue: Int? {
            return nil
        }
        
        public var stringValue: String {
            return key
        }
    }
    
    class JSONAny: Codable {
        
        let value: Any
        
        static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
            let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
            return DecodingError.typeMismatch(JSONAny.self, context)
        }
        
        static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
            let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
            return EncodingError.invalidValue(value, context)
        }
        
        static func decode(from container: SingleValueDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if container.decodeNil() {
                return JSONNull()
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
            if let value = try? container.decode(Bool.self) {
                return value
            }
            if let value = try? container.decode(Int64.self) {
                return value
            }
            if let value = try? container.decode(Double.self) {
                return value
            }
            if let value = try? container.decode(String.self) {
                return value
            }
            if let value = try? container.decodeNil() {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer() {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
            if let value = try? container.decode(Bool.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Int64.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(Double.self, forKey: key) {
                return value
            }
            if let value = try? container.decode(String.self, forKey: key) {
                return value
            }
            if let value = try? container.decodeNil(forKey: key) {
                if value {
                    return JSONNull()
                }
            }
            if var container = try? container.nestedUnkeyedContainer(forKey: key) {
                return try decodeArray(from: &container)
            }
            if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
                return try decodeDictionary(from: &container)
            }
            throw decodingError(forCodingPath: container.codingPath)
        }
        
        static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
            var arr: [Any] = []
            while !container.isAtEnd {
                let value = try decode(from: &container)
                arr.append(value)
            }
            return arr
        }
        
        static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
            var dict = [String: Any]()
            for key in container.allKeys {
                let value = try decode(from: &container, forKey: key)
                dict[key.stringValue] = value
            }
            return dict
        }
        
        static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
            for value in array {
                if let value = value as? Bool {
                    try container.encode(value)
                } else if let value = value as? Int64 {
                    try container.encode(value)
                } else if let value = value as? Double {
                    try container.encode(value)
                } else if let value = value as? String {
                    try container.encode(value)
                } else if value is JSONNull {
                    try container.encodeNil()
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer()
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
            for (key, value) in dictionary {
                let key = JSONCodingKey(stringValue: key)!
                if let value = value as? Bool {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Int64 {
                    try container.encode(value, forKey: key)
                } else if let value = value as? Double {
                    try container.encode(value, forKey: key)
                } else if let value = value as? String {
                    try container.encode(value, forKey: key)
                } else if value is JSONNull {
                    try container.encodeNil(forKey: key)
                } else if let value = value as? [Any] {
                    var container = container.nestedUnkeyedContainer(forKey: key)
                    try encode(to: &container, array: value)
                } else if let value = value as? [String: Any] {
                    var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                    try encode(to: &container, dictionary: value)
                } else {
                    throw encodingError(forValue: value, codingPath: container.codingPath)
                }
            }
        }
        
        static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
        
        public required init(from decoder: Decoder) throws {
            if var arrayContainer = try? decoder.unkeyedContainer() {
                self.value = try JSONAny.decodeArray(from: &arrayContainer)
            } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
                self.value = try JSONAny.decodeDictionary(from: &container)
            } else {
                let container = try decoder.singleValueContainer()
                self.value = try JSONAny.decode(from: container)
            }
        }
        
        public func encode(to encoder: Encoder) throws {
            if let arr = self.value as? [Any] {
                var container = encoder.unkeyedContainer()
                try JSONAny.encode(to: &container, array: arr)
            } else if let dict = self.value as? [String: Any] {
                var container = encoder.container(keyedBy: JSONCodingKey.self)
                try JSONAny.encode(to: &container, dictionary: dict)
            } else {
                var container = encoder.singleValueContainer()
                try JSONAny.encode(to: &container, value: self.value)
            }
        }
    }
}
