//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer


//TODO: Lots of !!

extension MastodonServer {
    

    //MARK: - Instance Data
    public func fetchInstanceProfile() async -> InstanceProfile? {
        let url = try! urlFrom(path: actions["instance"]!.endPointPath)
        return await fetchObject(ofType: InstanceProfile.self, from: url, withAuth: false)
    }
//    
    public func fetchInstanceTrends() async -> [TagTrend]? {
        let url = try! urlFrom(path: actions["trends"]!.endPointPath)
        return await fetchObject(ofType: [TagTrend].self, from: url, withAuth: false)
    }
//    
    //public func peers() {
    //
    //}
    //
    //public func activity() {
    //
    //}
    //
    //public func directory() {
    //
    //}
    //
    //public func emojis() {
    //
    //}
}

//MARK: - Timelines
    
extension MastodonServer {
    
    public func publicTimeline(itemCount:Int = 20) async throws -> [StatusItem] {
        let url = try urlFrom(endpoint: publicTimelineEndpoint(count: itemCount))
        
        //let result = try await requestService.fetchValue(ofType: [StatusItem?].self, from: url)
        print("trying to fetch store")
        let result = try await fetchCollectionOfOptionals(ofType: StatusItem.self, from: url, withAuth: false)
        let validOnly = result.compactMap { $0 }
        print("\(result.count - validOnly.count) items could not be rendered")
        return validOnly
    }
    
    public func tagTimeline(tag:String, itemCount:Int = 5) async throws -> [StatusItem] {
        let url = try urlFrom(endpoint: singleTagEndpoint(for: tag, count: itemCount))
        print("trying to fetch store")
        let result = try await fetchCollectionOfOptionals(ofType: StatusItem.self, from: url, withAuth: false)
        let validOnly = result.compactMap { $0 }
        print("\(result.count - validOnly.count) items could not be rendered")
        return validOnly
    }
    
    //TODO: Switch to "actions" lookup
    //see https://docs.joinmastodon.org/methods/timelines/
    private func publicTimelineEndpoint(count:Int) -> Endpoint {
        let config = TimelineConfiguration(limit: count)
        let path = actions["public_timeline"]?.fullPath
        return Endpoint(path: path!, queryItems: config.makeQueries())
        //return Endpoint(path: "/timelines/\(who)", queryItems: [URLQueryItem(name: "limit", value: "\(count)")])
    }
    

    //see https://docs.joinmastodon.org/methods/timelines/#hashtag-timeline
    private func singleTagEndpoint(for tag:String, count:Int) -> Endpoint {
        let path = actions["tag_timeline"]?.fullPath.replacingOccurrences(of: "{tag}", with: tag)
        return Endpoint(path: path!, queryItems: [URLQueryItem(name: "limit", value: "\(count)")])
    }

    
}

//extension MastodonServer {
//
////MARK: - Account Information
//public func getFollowing(for account:String) async {
//    do {
//        let url = try urlFrom(path: buildAccountInfoPath(account: account, forKey: "following"), prependBasePath: false)
//        let result = try await fetchRawString(from: url, encoding: .utf8)
//        print(result)
//    } catch {
//        print(error)
//    }
//}
//
//private func buildAccountInfoPath(account:String, forKey key:String) throws -> String {
//    let root = actions["id"]?.fullPath.replacingOccurrences(of: "{handle}", with: account) ?? ""
//    let path = actions[key]?.fullPath.replacingOccurrences(of: "{id_string}", with: root)
//
//    print(path ?? "no path")
//
//    guard var path else {
//        throw MastodonAPIError("Could not build path from keys")
//    }
//
//    path = path.appending(".json")
//    print(path)
//    return path
//}

//private func activityPubStyleJSON(forUsername:String, forKey key:String) throws -> Endpoint {
//    let root = apiversion.publicDataEndpointPaths["id"]?.replacingOccurrences(of: "{handle}", with: forUsername) ?? ""
//    let path = apiversion.publicDataEndpointPaths[key]?.replacingOccurrences(of: "{id_string}", with: root)
//    
//    print(path ?? "no path")
//    
//    guard var path else {
//        throw MastodonAPIError("Could not build path from keys")
//    }
//    
//    path = path.appending(".json")
//    
//    return Endpoint(path: path, queryItems: [])
//}

//}
