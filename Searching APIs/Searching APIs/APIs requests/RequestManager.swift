import Foundation

enum RequestError {
    case incorrectUrl
    case networkError(error: Error)
    case serverError(statusCode: Int)
    case parsingError(error: Error)
    case unknown
}

protocol RequestManager {
    func getUrlWith(url: String, path: String, params: [String: String]?) -> URL?
}

extension RequestManager {
    
    func getUrlWith(url: String, path: String, params: [String: String]? = nil) -> URL? {
        
        guard var components = URLComponents(string: url + path) else { return nil }
        if let params = params {
            components.queryItems = params.map({
                URLQueryItem(name: $0.key, value: $0.value)
            })
        }
        
        return components.url
    }
}
