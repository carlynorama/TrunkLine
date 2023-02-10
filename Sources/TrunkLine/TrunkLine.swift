import APItizer
import Foundation

public struct TrunkLine {
    public private(set) var text = "Hello, World!"

    public init() {
    }
    
    public static func fetchAuthFromKeychain(account:String, service:String, keyBase:String = Authentication.defaultKeyBase) throws -> Authentication {
        do {
            let new = try Authentication.makeFromKeyChain(account: account, service: service, keyBase: keyBase)
            return new
        }
        catch {
            throw MastodonAPIError("Unable to authorize: \(error.localizedDescription)")
        }
        
    }
    
    public static func fetchAuthFromEnvironment(account:String, service:String, tokenKey:String, secretsFile:URL? = nil) throws -> Authentication {
        do {
            let new = try Authentication.makeFromEnvironment(accountName: account, service: service, tokenKey: tokenKey)
            return new
        }
        catch {
            throw MastodonAPIError("Unable to authorize: \(error.localizedDescription)")
        }
        
    }
    
    public static func makeAuth(token:String, account:String, service:String, keyBase:String = Authentication.defaultKeyBase) throws -> Authentication {
        do {
            let new = try Authentication.makeWithTokenInhand(token: token, account: account, service: service, keyBase: keyBase)
            return new
        }
        catch {
            throw MastodonAPIError("Unable to authorize: \(error.localizedDescription)")
        }
        
    }
}
