import Foundation

struct GitHubParameters {
        
    static func createParameters(with searchText: String,
                                 and page: Int = 1) -> [String: String] {
        let parameters = ["q": searchText.replacingOccurrences(of: " ", with: "+"),
                          "page": String(page)]
        return parameters
    }
}
