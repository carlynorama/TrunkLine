//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation
import APItizer

public enum MastodonAPIError: Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    fileprivate init(_ message: String) {
        self = .message(message)
    }
}

//apiBase: "/api/v1"
public struct MastodonServer:APIServer, Authorizable {
    public private(set)var scheme: Scheme
    public private(set) var host: URL
    public private(set) var apiversion: APIVersion
    
    public var version: String? {
        apiversion.description
    }
    
    public var apiBase: String? {
        apiversion.urlString
    }
    
    public enum APIVersion {
        case v1
        
        var urlString:String {
            "/api/v1"
        }
        
        var description:String {
            "v1"
        }
    }
    
    public init(host:URL, version:APIVersion, scheme:Scheme = .https) {
        self.host =  host
        self.apiversion =  version
        self.scheme = scheme
    }
    
    //TODO: What happens in the app if the network connection fails?
    
    //MARK: - Instance Data
    public func fetchProfile() async -> InstanceProfile? {
        await fetchObject(ofType: InstanceProfile.self, fromPath: "/instance")
    }
    
    public func fetchTrends() async -> [TagTrend]? {
        //_ = await fetchJSON(fromPath: "/trends")
        await fetchObject(ofType: [TagTrend].self, fromPath: "/trends")
    }
    
    public func peers() {
        
    }
    
    public func activity() {
        
    }
    
    public func directory() {
        
    }
    
    public func emojis() {
        
    }
    
    
    
    
    //MARK: - Timelines
    
    public func publicTimeline(itemCount:Int = 20) async throws -> [StatusItem] {
        let url = try urlFrom(endpoint: publicTimelineEndpoint(count: itemCount))
        
            //let result = try await requestService.fetchValue(ofType: [StatusItem?].self, from: url)
        print("trying to fetch store")
        let result = try await fetchCollectionOfOptionals(ofType: StatusItem.self, from: url)
        let validOnly = result.compactMap { $0 }
        print("\(result.count - validOnly.count) items could not be rendered")
        return validOnly
    }
    
    public func tagTimeline(tag:String, itemCount:Int = 1) async throws -> [StatusItem] {
            let url = try urlFrom(endpoint: singleTagEndpoint(for: tag, count: itemCount))
            print("trying to fetch store")
            let result = try await fetchCollectionOfOptionals(ofType: StatusItem.self, from: url)
            let validOnly = result.compactMap { $0 }
            print("\(result.count - validOnly.count) items could not be rendered")
            return validOnly
    }
    
    //MARK: Status item detals
    
    //MARK: - Account Information
    public func getFollowing(for account:String) async {
        do {
            let url = try urlFrom(path: pathForJSON(account: account, forKey: "following"), usingAPIBase: false)
            let result = try await fetchRawString(from: url, encoding: .utf8)
            print(result)
        } catch {
            print(error)
        }
    }

    
    //MARK: Endpoints
    
    let apJSONEndpointPaths = [
        "id" : "/users/{handle}",
        "following" : "{id_string}/following",
        "followers" : "{id_string}/followers",
        "liked" : "{id_string}/liked",
        "inbox" : "{id_string}/inbox",
        "outbox" : "{id_string}/outbox"
    ]
    
    private func pathForJSON(account:String, forKey key:String) throws -> String {
        let root = apJSONEndpointPaths["id"]?.replacingOccurrences(of: "{handle}", with: account) ?? ""
        let path = apJSONEndpointPaths[key]?.replacingOccurrences(of: "{id_string}", with: root)
        
        print(path ?? "no path")
        
        guard var path else {
            throw MastodonAPIError("Could not build path from keys")
        }
        
        path = path.appending(".json")
        print(path)
        return path
    }
    
    private func activityPubStyleJSON(forUsername:String, forKey key:String) throws -> Endpoint {
        let root = apJSONEndpointPaths["id"]?.replacingOccurrences(of: "{handle}", with: forUsername) ?? ""
        let path = apJSONEndpointPaths[key]?.replacingOccurrences(of: "{id_string}", with: root)
        
        print(path ?? "no path")
        
        guard var path else {
            throw MastodonAPIError("Could not build path from keys")
        }
        
        path = path.appending(".json")
        
        return Endpoint(path: path, queryItems: [])
    }
    
    
    //see https://docs.joinmastodon.org/methods/timelines/
    private func publicTimelineEndpoint(for who:String = "public", count:Int) -> Endpoint {
        Endpoint(path: "/timelines/\(who)", queryItems: [URLQueryItem(name: "limit", value: "\(count)")])
    }
    
    //see https://docs.joinmastodon.org/methods/timelines/#hashtag-timeline
    private func singleTagEndpoint(for what:String, count:Int) -> Endpoint {
        Endpoint(path: "/timelines/tag/\(what)", queryItems: [URLQueryItem(name: "limit", value: "\(count)")])
    }
}
