//
//  ServerSentEventListener.swift
//  
//
//  Created by Carlyn Maw on 2/17/23.
//
// In that case you need to use the URLSession delegate-based APIs (dataTask(with:) and so on), which will call the urlSession(_:dataTask:didReceive:) session delegate method with chunks of data as they arrive.
//https://stackoverflow.com/questions/44602192/how-to-use-urlsessionstreamtask-with-urlsession-for-chunked-encoding-transfer/75466620#75466620
//https://www.hackingwithswift.com/articles/241/how-to-fetch-remote-data-the-easy-way-with-url-lines
// "The right way"?:https://github.com/launchdarkly/swift-eventsource/blob/main/Source/LDSwiftEventSource.swift

//------------- SPEC
//https://html.spec.whatwg.org/multipage/server-sent-events.html#event-stream-interpretation

//Streams must be decoded using the UTF-8 decode algorithm.
//
//The UTF-8 decode algorithm strips one leading UTF-8 Byte Order Mark (BOM), if any.
//
//The stream must then be parsed by reading everything line by line, with a U+000D CARRIAGE RETURN U+000A LINE FEED (CRLF) character pair, a single U+000A LINE FEED (LF) character not preceded by a U+000D CARRIAGE RETURN (CR) character, and a single U+000D CARRIAGE RETURN (CR) character not followed by a U+000A LINE FEED (LF) character being the ways in which a line can end.
//------------- \SPEC



import Foundation
import APItizer

@Sendable
public func debugStatus(_ string:String) {
    _ = string.data(using: .utf8)!.verboseDecode(ofType: MastodonServer.StatusItem.self)
    print("----------------------------------")
    print(string)
    print("----------------------------------")
}

if !os(Linux)
extension MastodonServer {
    public enum MastodonStreamEvent:Hashable {
        //case dictionary([String:String])
        case new(StatusItem) //"update"
        case updated(StatusItem) //"status.update"
        case deletedID(String) //ID number or Status... API says one, stream does another?
        case notification(String) //TODO: Notification type.
        case filters_changed(String?)
        case conversation(String) //TODO: Conversation type
        case announcement(String) //TODO: Announcement type
        case announcementAction(String) //TODO: announcement.reaction, announcement.delete
        case encrypted_message(String) //currently unused
        case unimplemented(String?, String?)
        case couldNotEncode(String?, String?)
        case unlabled(String?)
    }
    
    

    
    mutating public func getSSEStream(url:URL, withAtuh:Bool = false) async throws -> AsyncStream<MastodonStreamEvent> {
        if streamService == nil {
            if withAtuh {
                print(authentication)
                //TODO: needed auth is nil handling. Job for delegate? 
                streamService = SSEListener(url: url, authentication: authentication)
            }
            else {
                streamService = SSEListener(url: url)
            }
        }
        else {
            //TODO: Build in the ability to handle more than one stream. In SSEListener or MastodonServer or combined.
            throw MastodonAPIError("Someone is already streaming...")
        }
        let result = streamService!.eventStream().map { event in
            switch event.message {
            case "update":
                if let item = try? await event.data!.data(using: .utf8)!.asValue(ofType: StatusItem.self) { return MastodonStreamEvent.new(item) }
                else {
                    MastodonServer.StatusItem.debugDecoder(event.data!)
                    return MastodonStreamEvent.couldNotEncode(event.message, event.data)
                }
            case "status.update":
                if let item = try? await event.data!.data(using: .utf8)!.asValue(ofType: StatusItem.self) { return  MastodonStreamEvent.updated(item) }
                else {
                    MastodonServer.StatusItem.debugDecoder(event.data!)
                    return MastodonStreamEvent.couldNotEncode(event.message, event.data)
                }
            case "delete":
                return MastodonStreamEvent.deletedID(event.data!)
            case "notification":
                return MastodonStreamEvent.notification(event.data!)
            case .none:
                return MastodonStreamEvent.unlabled(event.data == nil ? event.lastEventId : event.data)
            case .some(let type):
                return MastodonStreamEvent.unimplemented(type, event.data)
            }
//                let mse = MastodonStreamEvent.dictionary(
//                    ["type" : event.message ?? "undefined",
//                     "data" : event.data ?? "empty"]
//                )
//                return mse
            }
        //extension in APItizer
        return AsyncStream(result)
        //return transformedStream(someSequence: someSequence)
    }
    
    

    
    mutating public func endSSEStream() throws {
        try streamService?.stopListening()
        streamService = nil
    }
    
}

//TODO: Is this in 5.8???
//https://forums.swift.org/t/when-can-we-move-asyncsequence-forward/61991/2
fileprivate extension AsyncStream {
  init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
    var iterator: S.AsyncIterator?
    self.init {
      if iterator == nil {
        iterator = sequence.makeAsyncIterator()
      }
      return try? await iterator?.next()
    }
  }
}
#endif