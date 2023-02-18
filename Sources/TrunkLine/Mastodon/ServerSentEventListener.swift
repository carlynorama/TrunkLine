//
//  ServerSentEventListener.swift
//  
//
//  Created by Carlyn Maw on 2/17/23.
//
// In that case you need to use the URLSession delegate-based APIs (dataTask(with:) and so on), which will call the urlSession(_:dataTask:didReceive:) session delegate method with chunks of data as they arrive.
//https://stackoverflow.com/questions/44602192/how-to-use-urlsessionstreamtask-with-urlsession-for-chunked-encoding-transfer/75466620#75466620
//https://www.hackingwithswift.com/articles/241/how-to-fetch-remote-data-the-easy-way-with-url-lines


//------------- SPEC
//https://html.spec.whatwg.org/multipage/server-sent-events.html#event-stream-interpretation

//Streams must be decoded using the UTF-8 decode algorithm.
//
//The UTF-8 decode algorithm strips one leading UTF-8 Byte Order Mark (BOM), if any.
//
//The stream must then be parsed by reading everything line by line, with a U+000D CARRIAGE RETURN U+000A LINE FEED (CRLF) character pair, a single U+000A LINE FEED (LF) character not preceded by a U+000D CARRIAGE RETURN (CR) character, and a single U+000D CARRIAGE RETURN (CR) character not followed by a U+000A LINE FEED (LF) character being the ways in which a line can end.
//------------- \SPEC



import Foundation

public struct SSEStreamEvent:Hashable {
    public let lastEventId:String?
    public let message:String?
    public let data:String?
    public let sourceURL:URL  //resolve after redirects?
    public let withCredentials:Bool
    
    var description:String {
        "Event with lastID\(lastEventId ?? "") type:\(message ?? "") with \(data?.count ?? 0) bytes"
    }
}

enum SSEListenerError: Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    init(_ message: String) {
        self = .message(message)
    }
}

public class SSEListener: NSObject, URLSessionDataDelegate {
    private var urlRequest: URLRequest
    private var session: URLSession! = nil
    
    private var dataTask:URLSessionDataTask?
    private var task:Task<Void, Error>?
    
    var isListening:Bool {
        dataTask != nil
    }
    
    public init(url:URL, urlSession:URLSession? = nil) {
        //--------- SPEC
        //GET
        //Accept: text/event-stream
        //Cache-Control: no-cache
        //Connection: keep-alive
        //--------- \SPEC
        var request = URLRequest(url: url,cachePolicy: .reloadIgnoringLocalCacheData)
        request.setValue("text/event-stream", forHTTPHeaderField:"Accept")
        //TODO: confirm that keep-alive & no cache are true
        self.urlRequest = request
        
        super.init()
        if urlSession != nil {
            self.session = urlSession!
        } else {
            let config = URLSessionConfiguration.default
            config.requestCachePolicy = .reloadIgnoringLocalCacheData
            self.session = URLSession(configuration: config, delegate: self, delegateQueue: .main)
        }
    }
    
    deinit {
        self.cancel()
    }
    
    public func eventStream() -> AsyncThrowingStream<SSEStreamEvent, Error> {
        return AsyncThrowingStream { continuation in
            if task != nil { task?.cancel() }
            task = Task {
                
                if dataTask != nil { dataTask?.cancel() }
                let (asyncBytes, _) = try await self.session.bytes(for: self.urlRequest)
                self.dataTask = asyncBytes.task

                //SPEC: When a stream is parsed, a data buffer, an event type buffer, and a last event ID buffer must be associated with it.
                //SPEC: They must be initialized to the empty string.
                var eventBuilder:[String:String] = [:]
                
                //asyncBytes.lines ignores empty lines had to make my own
                var iterator = asyncBytes.allLines_v1.makeAsyncIterator()
                while let line = try await iterator.next() {
                    try Task.checkCancellation()
                    print("line in loop: \(line)")
                    let decodedLine = try await SSELine(line)
                    switch decodedLine {
                    case .event(let event_type):
                        //SPEC: Set the event type buffer to field value.
                        eventBuilder["event_type"] = event_type
                    case .data(let new_data):
                        print("data: \(new_data.count)")
                        //SPEC: Append the field value to the data buffer, then append a single U+000A LINE FEED (LF) character to the data buffer.
                        var currentData = ""
                        if eventBuilder["data"] != nil {
                            currentData.append(contentsOf: eventBuilder["data"]!)
                        }
                        currentData.append(contentsOf: new_data)
                        currentData.append("\u{000A}")
                        eventBuilder["data"] = currentData
                    case .id(let id):
                        //SPEC: set the last event ID buffer to the field value
                        eventBuilder["last_event_ID"] = id
                    case .retry(let time):
                        setReconnectionTime(time)
                    case .ignore:
                        print("ignore me")
                        break
                    case .dispatch:
                        if let sse = makeSSESrreamEvent(tryWith: eventBuilder) {
                            print(sse)
                            continuation.yield(sse)
                        } else { print("something went wrong")}
                        eventBuilder["data"] = ""
                        eventBuilder["event_type"] = ""
                    }
                }
            }
            continuation.onTermination = { @Sendable _ in
                self.cancel()
            }
        }

        
    }
    
    func makeSSESrreamEvent(tryWith tmp:[String:String]) -> SSEStreamEvent? {
        print(tmp)
        if tmp.isEmpty { return nil }
        if tmp.allSatisfy({ $1.isEmpty }) { return nil }
        var eventBuilder = tmp
        if var data:String = eventBuilder["data"] {
            if data.isEmpty { eventBuilder["event_type"] = "" }
            if data.last == "\u{000A}" {  _ = data.popLast() }
        }
        return (SSEStreamEvent(
            lastEventId: eventBuilder["last_event_ID"],
            message: eventBuilder["event_type"],
            data: eventBuilder["data"],
            sourceURL:urlRequest.url!,
            withCredentials:false)
        )
    }
    //set the event stream's reconnection time to that integer
    func setReconnectionTime(_ time:Int) {
        print("do something with this \(time)")
    }
    
    func watchStream(handler:@escaping (SSEStreamEvent)->Void) async throws {
        for try await event in eventStream() {
            handler(event)
        }
    }
    
    public func stopListening() throws {
        self.cancel()
    }
    
    private func cancel() {
        dataTask?.cancel()
        task?.cancel()
        dataTask = nil
    }
    
    
    enum SSELine {
        case event(String), data(String), id(String), retry(Int), ignore, dispatch
        
        init(_ candidateString:String) async throws {
            //print(candidateString)
            
            //SPEC: If the line is empty (a blank line) Dispatch the event
            if candidateString.isEmpty { self = Self.dispatch; return }
            
            //SPEC: If the line starts with a U+003A COLON character (:) Ignore the line.
            if candidateString.prefix(1) == ":" { self = Self.ignore; return }
            
            //SPEC: If the line contains a U+003A COLON character (:)
            //SPEC: Collect the characters on the line before the first U+003A COLON character (:), and let field be that string. Collect the characters on the line after the first U+003A COLON character (:), and let value be that string.
            var splitResult = candidateString.split(separator: ":", maxSplits: 1).map(String.init)
            
            
            guard splitResult.count == 2 else {
                print("SSELine init couldn't make proper split from:\(candidateString)")
                self = Self.ignore; return
            }
            
            //SPEC: If value starts with a U+0020 SPACE character, remove it from value.
            //" ", ASCII 32, does seem to work, but might as well be explicit.
            if splitResult[1].prefix(1) == "\u{0020}" {
                //splitResult[1] = String(splitResult[1].trimmingPrefix(while: \.isWhitespace))
                splitResult[1] = String(splitResult[1].trimmingPrefix(while: {$0 == "\u{0020}"}))
            }
            
            switch splitResult[0] {
            case "event":
                self = Self.event(splitResult[1])
            case "data":
                self = Self.data(splitResult[1])
            case "retry":
                //SPEC: If the field value consists of only ASCII digits, then interpret the field value as an integer in base ten, and set the event stream's reconnection time to that integer. Otherwise, ignore the field.
                if let value = Int(splitResult[1]) { self = Self.retry(value) }
                else { self = Self.ignore }
            case "id":
                //SPEC: If the field value does not contain U+0000 NULL, then set the last event ID buffer to the field value. Otherwise, ignore the field.
                if !splitResult[1].contains("\u{0000}") { self = Self.id(splitResult[1]) }
                else { self = Self.ignore }
            default:
                self = Self.ignore
            }
        }
    }
    
    public func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        //NSLog("task data: %@", data as NSData)
        print("task data: %@", data as NSData)
    }
    
    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error as NSError? {
            //NSLog("task error: %@ / %d", error.domain, error.code)
            print("task error: %@ / %d", error.domain, error.code)
        } else {
            print("task complete")
            //NSLog("task complete")
        }
    }
}

extension AsyncSequence where Element == UInt8 {
    //Works.
    var allLines_v1:AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            let bytesTask = Task {
                var accumulator:[UInt8] = []
                var iterator = self.makeAsyncIterator()
                while let byte = try await iterator.next() {
                    //10 == \n
                    if byte != 10 { accumulator.append(byte) }
                    else {
                        if accumulator.isEmpty { continuation.yield("") }
                        else {
                            if let line = String(data: Data(accumulator), encoding: .utf8) { continuation.yield(line) }
                            else { throw MastodonAPIError("allLines: Couldn't make string from [UInt8] chunk") }
                            accumulator = []
            }   }   }   }
            continuation.onTermination = { @Sendable _ in
                bytesTask.cancel()
    }   }   }
    
    //This code... looses bytes? Looses every-other packet somehow?
    //Something isn't right with the accumulator.
    //setting it to [] or not doesn't seem to make a difference, and it should?
//    var allLines_v2:AsyncThrowingStream<String, Error> {
//        return AsyncThrowingStream {
//            var accumulator:[UInt8] = []
//            for try await byte in self {
//                //10 == \n
//                if byte != 10 { accumulator.append(byte) }
//                else {
//                    if accumulator.isEmpty { return "" }
//                    else {
//                        //print(String(data: Data(accumulator), encoding: .utf8))
//                        if let line = String(data: Data(accumulator), encoding: .utf8) {
//                            //accumulator = [];
//                            print("allLines_v2: \(line)")
//                            return line
//                        }
//                        else {
//                            //accumulator = [];
//                            throw MastodonAPIError("allLines: Couldn't make string from [UInt8] chunk") }
//             }    }   }
//            return nil
//        }
//    }
}

