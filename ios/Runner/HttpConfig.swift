import Foundation

class HttpConfig {
    static let shared = HttpConfig()
    
    private init() {}
    
    var baseUrl: String?
    var authorizationToken: String?
    
    func configure(baseUrl: String, authorizationToken: String) {
        self.baseUrl = baseUrl
        self.authorizationToken = authorizationToken
    }
}
