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
    
    
//    public func newPostWithOneImage(_ message:String, imageURL:URL, imageAltText:String) async throws {
//
//        let attachment = try MinimalAttachable.makeFromFile(url: imageURL, limitTypes: [.gif, .jpeg, .png])
//
//        guard let mediaId = try? await uploadMediaAttachment(attachment: attachment, imageAltText: imageAltText) else {
//            throw MastodonAPIError("Did not reiceve mediaID")
//        }
//
//        print("trying to post... \(message)")
//        let path:String? = actions["new_status"]?.fullPath
//        let url = try? urlFrom(path: path!, usingAPIBase: true)
//        var header:[String:String] = [:]
//        if let authentication {
//            header = try authentication.appendAuthHeader(to:header)
//        } else {
//            throw MastodonAPIError.message("No authentication information avialable")
//        }
//
//        header["Content-Type"] = "application/x-www-form-urlencoded; charset=utf-8"
//
//        if let payload = try? StatusConfiguration(status: message, media_ids: [mediaId]).makeURLEncodedData() {
//            //TODO: BAD - I'm pointing at a RequestService implmentation.
//            let request =  HTTPRequestService.buildRequest(for: url!, with: header, using: .post, sending:payload)!
//            let (data, response) = try await URLSession.shared.data(for: request)
//            print(data, response)
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200  else  {
//                print(response)
//                throw MastodonAPIError("Did not post message, but did make mediaID \(mediaId)?")
//            }
//            //return data
//
//        } else {
//            throw MastodonAPIError("Could not make valid form data.")
//        }
//
//
//        //let formBuilder = MultiPartFormBuilder()
//        //https://docs.joinmastodon.org/methods/media/
    //let url = URL(string:"https://reqres.in/api/")!
//
//
//
//    }
//    public func uploadMediaAttachment(imageURL:URL, token:String) async throws {
//        print("made it to upMeA")
//        guard var data = try? Data(contentsOf: imageURL) else {
//            throw MastodonAPIError("MinimalAttachable:No data for the file at the location given.")
//        }
//        let mimeType = imageURL.mimeType()
//        print("mimeType:\(mimeType)")
//
//        // generate boundary string using a unique per-app string
//          let boundary = UUID().uuidString
//
//
//
//            let path:String? = actions["upload_media"]?.fullPath
//
//            let url = (try? urlFrom(path: path!, usingAPIBase: true))!
//            print("url: \(url)")
//
//        //let url = URL(string: "https://postman-echo.com/post?test=123")!
//        //let url = URL(string: "https://reqres.in/api/")!
//
//          // Set the URLRequest to POST and to the specified URL
//          var urlRequest = URLRequest(url: url)
//          urlRequest.httpMethod = "POST"
//
//
//        urlRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
//
//          // Set Content-Type Header to multipart/form-data, this is equivalent to submitting form data with file upload in a web browser
//          // And the boundary is also set here
//          urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//
//          let paramName = "file"
//          let fileName = "myFileName"
//
//          // Add the image data to the raw http request data
//          data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//          data.append("Content-Disposition: form-data; name=\"\(paramName)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//          data.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
//          data.append(data)
//
//
//        let key = "description"
//        let value = "more pretty flowers for tests with doodles on top"
//
//        var fieldString = "--\(boundary)\r\n"
//        fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
//        fieldString += "Content-Type: text/plain; charset=UTF-8\r\n"
//        fieldString += "\r\n"
//        fieldString += "\(value)\r\n"
//
//        data.append(fieldString.data(using: .utf8)!)
//
//
//          data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//          // Send a POST request to the URL, with the data we created earlier
//        let (responseData, response) = try await URLSession.shared.upload(for: urlRequest, from: data)
//
//        print("----")
//        print(String(data:responseData, encoding: .utf8) ?? "Nothing")
//        print("----")
//        print(response)
//       print("----")
//
////          let session = URLSession.shared
////          session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
////              if error == nil {
////                  print("...printing response")
////                  let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
////                  if let json = jsonData as? [String: Any] {
////                      print(json)
////                  }
////              } else {
////                  print(error)
////              }
////          }).resume()
//
//    }
    
//  }
    

    
//    private func uploadMediaAttachment(attachment:Attachable, imageAltText:String) async throws ->  String {
//        //print("trying to post... \(string)")
//        let path:String? = actions["upload_media"]?.fullPath
//        let url = URL(string:"https://reqres.in/api/")!
//        //let url = (try? urlFrom(path: path!, usingAPIBase: true))!
//        print(url)
//        var header:[String:String] = [:]
////        if let authentication {
////            header = try authentication.appendAuthHeader(to:header)
////        } else {
////            throw MastodonAPIError.message("No authentication information avialable")
////        }
//
//        let amc = MediaAttachmentCofiguration(file: attachment, thumbnail: nil, description: imageAltText, focus_x: nil, focus_y: nil)
//        print(amc)
//
//        if let payload = amc.makeFormBody() {
//            print(String(data:payload.currentState, encoding: .utf8))
//            print("\(payload.terminatedPayloadString)")
//            header["Content-Type"] = payload.contentTypeHeader
//            print(header)
//
//
//
//            guard let request = HTTPRequestService.buildRequest(for: url, with: header, using: .post, sending: payload.terminatedPayload) else {
//                throw MastodonAPIError("Could not build request")
//            }
//            let (data, response) = try await URLSession.shared.data(for: request)
//            print(data, response)
//            //TODO Handle other cases. 202 for larger files now, for example.
//            guard let response = response as? HTTPURLResponse,
//                  response.statusCode == 200  else  {
//                         throw MastodonAPIError("HTTP Response not 200")
//            }
//
//            guard let mediaItem = try await data.asOptional(ofType: ItemMediaAttachment.self) else {
//                throw MastodonAPIError("Couldn't make mediaItem from response")
//            }
//            print(mediaItem)
//
//            return (mediaItem.id)
//
//              return ""
//
//        } else {
//            throw MastodonAPIError("Could not make payload for Media Attachment")
//        }
//    }
//
//}
