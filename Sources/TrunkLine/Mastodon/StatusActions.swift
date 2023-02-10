//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer

extension MastodonServer {
    
    public func testStatusCreation() {
        do {
//            let newStatus = try APIVersion.StatusConfiguration(status: "hello message", media_ids: ["id1", "id2"])
//            print(newStatus.makeQueries())
//            let newStatus2 = try APIVersion.StatusConfiguration(status: "", media_ids: ["id1", "id2"])
//            print(newStatus2.makeQueries())
            let newStatus3 = try APIVersion.StatusConfiguration(status: "other hello")
//            print(newStatus3.makeQueries())
////            let newStatus4 = try APIVersion.StatusConfiguration(status: "", media_ids: [])
////            print(newStatus4.makeQueries())
//            let newStatus5 = try APIVersion.StatusConfiguration(status: nil, media_ids: nil)
//            print(newStatus5.makeQueries())
            var components = URLComponents()
            components.scheme = "https"
            components.host = host.absoluteString
            components.path = apiBase! + "/statuses/"
            //components.queryItems = newStatus3.makeQueries()
            
            guard let url = components.url else {
                print("components:\(components)")
                return
                //throw Error("Invalid url for endpoint")
            }
            print(url)
        } catch {
            print(error)
        }
    }
    
    public func writeSimpleStatus(string:String) async throws {
        print("trying to post... \(string)")
        let path = apiversion.endpointPaths["new_status"]
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        var header:[String:String] = [:]
        if let authentication {
            header = try authentication.appendAuthHeader(to:header)
            
        } else {
            throw MastodonAPIError.message("No authentication information avialable")
        }
        
        header["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        
        if let payload = try? APIVersion.StatusConfiguration(status: string).makeFormData() {
            //TODO: BAD - I'm pointing at a RequestService implmentation.
            let request =  HTTPRequestService.buildRequest(for: url!, with: header, using: .post, sending:payload)!
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, response)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200  else  {
                         throw MastodonAPIError("Did not post.")
            }
            //return data
            
        } else {
            throw MastodonAPIError("Could not make valid form data.")
        }
    }
    
}
