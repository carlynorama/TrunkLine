//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation
import APItizer

extension MastodonServer {
    public func newPost(message:String) async throws {
        let path:String? = actions["new_status"]?.endPointPath
        let url = try urlFrom(path: path!, prependBasePath: true)
        
        let returnData = try await post_URLEncoded(baseUrl:url, formData:["status":message], withAuth:true)
        
        print(String(data: returnData, encoding: .utf8)!)
    }
    
    
    
    
    //NOTE Media uses v2 so needs different handling.
    private func postMediaItem(fileAttachment:Attachment, altText:String) async throws -> String {
        let mediaEndpoint = Endpoint(path:"/api/v2/media", queryItems: [])
        let url = try urlFrom(endpoint: mediaEndpoint, prependBasePath: false)
        
        
        let psudeoConfig = [
            "description":altText
        ]
        
        let (boundary, body) = try MultiPartFormEncoder.makeBodyData(stringItems: psudeoConfig, attachments: ["file" : fileAttachment])
        
        let returnData = try await post_FormBody(baseUrl: url, dataToSend: body, boundary: boundary, withAuth: true)
        
        //FAILS
        //try await returnData.asValue(ofType: ItemMediaAttachment.self)
        guard let dictionary = try await returnData.asDictionary()  else {
            throw MastodonAPIError("TrunkLine postMediaItem could not make expected dictionary from return data.")
        }
        if let mediaID = dictionary["id"] as? String {
            return mediaID
        } else {
            throw MastodonAPIError("TrunkLine postMediaItem did not find ID in response.")
        }
        
    }
    
    public func attachmentBuilderTest(path:String) -> String {
        do {
            let attachment = try makeImageAttachment(filePath: path)
            return("yup \(attachment.fileName), \(attachment.mimeType)")
        } catch {
            return("nope")
        }
    }
    
    public func attachmentBuilderTest(url:URL) -> String {
        do {
            let attachment = try makeImageAttachment(fileURL: url)
            return("yup \(attachment.fileName), \(attachment.mimeType)")
        } catch {
            return("nope")
        }
    }
    
    func makeImageAttachment(filePath:String) throws -> Attachment {
        try Attachment.makeFromFile(path: filePath, limitTypes: [.image])
    }
    
    func makeImageAttachment(fileURL:URL) throws -> Attachment {
        try Attachment.makeFrom(url: fileURL, limitTypes: [.image] )
    }
    
    public func newPostWithImage(message:String, imageFilePath:String, imageAltText:String) async throws {
        
        
        let fileAttachment = try makeImageAttachment(filePath: imageFilePath)
        print("made file attachment.")
        let mediaID = try await postMediaItem(fileAttachment: fileAttachment, altText: imageAltText)
        print("posted media.")
        let statusConfig = try StatusConfiguration(status: message, media_ids: [mediaID])
        print("made satus config.")
        let statusConfigData = try statusConfig.makeURLEncodedData()
        
        let path:String? = actions["new_status"]?.endPointPath
        let url = try urlFrom(path: path!, prependBasePath: true)
        
        let returnData = try await post_URLEncoded(baseUrl: url, dataToSend: statusConfigData)
        
        print(String(data: returnData, encoding: .utf8)!)
        
    }
    
    func newPost() {
        
    }
    
    //    public func testPost() async throws {
    //
    //        let statusConfig = try StatusConfiguration(status: "This is a test message with a pre-uploaded media ID \(Date.now)", media_ids: ["109864064572998885", "109855908167179383"])
    //        print("made satus config.")
    //
    //        let statusConfigString = try statusConfig.makeURLEncodedString()
    //        let statusConfigData = try statusConfig.makeURLEncodedData()
    //
    //        print("------")
    //        print(statusConfigString)
    //        print("---")
    //        print(String(data:statusConfigData, encoding: .utf8))
    //        print("------")
    //
    //        let path:String? = actions["new_status"]?.endPointPath
    //        let url = try urlFrom(path: path!, prependBasePath: true)
    //
    //        let returnData = try await post_URLEncoded(baseUrl: url, dataToSend: statusConfigData)
    //
    //        print(String(data: returnData, encoding: .utf8)!)
    //
    //    }
    //
    
    
}

