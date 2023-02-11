//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer

extension MastodonServer {
    
//    public func testStatusCreation() {
//        do {
////            let newStatus = try APIVersion.StatusConfiguration(status: "hello message", media_ids: ["id1", "id2"])
////            print(newStatus.makeQueries())
////            let newStatus2 = try APIVersion.StatusConfiguration(status: "", media_ids: ["id1", "id2"])
////            print(newStatus2.makeQueries())
//            let newStatus3 = try StatusConfiguration(status: "other hello")
////            print(newStatus3.makeQueries())
//////            let newStatus4 = try APIVersion.StatusConfiguration(status: "", media_ids: [])
//////            print(newStatus4.makeQueries())
////            let newStatus5 = try APIVersion.StatusConfiguration(status: nil, media_ids: nil)
////            print(newStatus5.makeQueries())
//            var components = URLComponents()
//            components.scheme = "https"
//            components.host = host.absoluteString
//            components.path = apiBase! + "/statuses/"
//            //components.queryItems = newStatus3.makeQueries()
//
//            guard let url = components.url else {
//                print("components:\(components)")
//                return
//                //throw Error("Invalid url for endpoint")
//            }
//            print(url)
//        } catch {
//            print(error)
//        }
//    }
    
    public func writeSimpleStatus(string:String) async throws {
        print("trying to post... \(string)")
        let path:String? = actions["new_status"]?.fullPath
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        var header:[String:String] = [:]
        if let authentication {
            header = try authentication.appendAuthHeader(to:header)
        } else {
            throw MastodonAPIError.message("No authentication information avialable")
        }
        
        header["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        
        if let payload = try? StatusConfiguration(status: string).makeURLEncodedData() {
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
        

        //let formBuilder = MultiPartFormBuilder()
        //https://docs.joinmastodon.org/methods/media/
    }
    
    
    public func newPostWithOneImage(_ message:String, imageURL:URL, imageAltText:String) async throws {
        
        let attachment = try MinimalAttachable.makeFromFile(url: imageURL, limitTypes: [.gif, .jpeg, .png])
        
        guard let mediaId = try? await uploadMediaAttachment(attachment: attachment, imageAltText: imageAltText) else {
            throw MastodonAPIError("Did not reiceve mediaID")
        }
        
        print("trying to post... \(message)")
        let path:String? = actions["new_status"]?.fullPath
        let url = try? urlFrom(path: path!, usingAPIBase: true)
        var header:[String:String] = [:]
        if let authentication {
            header = try authentication.appendAuthHeader(to:header)
        } else {
            throw MastodonAPIError.message("No authentication information avialable")
        }
        
        header["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
        
        if let payload = try? StatusConfiguration(status: message, media_ids: [mediaId]).makeURLEncodedData() {
            //TODO: BAD - I'm pointing at a RequestService implmentation.
            let request =  HTTPRequestService.buildRequest(for: url!, with: header, using: .post, sending:payload)!
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, response)
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200  else  {
                print(response)
                throw MastodonAPIError("Did not post message, but did make mediaID \(mediaId)?")
            }
            //return data
            
        } else {
            throw MastodonAPIError("Could not make valid form data.")
        }
        

        //let formBuilder = MultiPartFormBuilder()
        //https://docs.joinmastodon.org/methods/media/
        
        
        
    }
    
    private func uploadMediaAttachment(attachment:Attachable, imageAltText:String) async throws ->  String {
        //print("trying to post... \(string)")
        let path:String? = actions["upload_media"]?.fullPath
        let url = (try? urlFrom(path: path!, usingAPIBase: true))!
        print(url)
        var header:[String:String] = [:]
        if let authentication {
            header = try authentication.appendAuthHeader(to:header)
        } else {
            throw MastodonAPIError.message("No authentication information avialable")
        }
        
        let amc = MediaAttachmentCofiguration(file: attachment, thumbnail: nil, description: imageAltText, focus_x: nil, focus_y: nil)
        print(amc)
        
        if let payload = amc.makeFormBody() {
            print("made payload")
            header["Content-Type"] = payload.contentTypeHeader
            guard let request = HTTPRequestService.buildRequest(for: url, with: header, using: .post, sending: payload.terminatedPayload) else {
                throw MastodonAPIError("Could not build request")
            }
            let (data, response) = try await URLSession.shared.data(for: request)
            print(data, response)
            //TODO Handle other cases. 202 for larger files now, for example.
            guard let response = response as? HTTPURLResponse,
                  response.statusCode == 200  else  {
                         throw MastodonAPIError("HTTP Response not 200")
            }
            
            guard let mediaItem = try await data.asOptional(ofType: ItemMediaAttachment.self) else {
                throw MastodonAPIError("Couldn't make mediaItem from response")
            }
            print(mediaItem)
            
            return (mediaItem.id)
            
        } else {
            throw MastodonAPIError("Could not make payload for Media Attachment")
        }
    }
    
}
