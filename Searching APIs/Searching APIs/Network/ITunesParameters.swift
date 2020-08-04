import Foundation

struct ITunesParameters {
    
    static let limitOfItem = 25
    
    static func createParameter(with searchText: String,
                         and offset: Int = 0) -> [String: String] {
        let parameters = ["term": searchText.replacingOccurrences(of: " ", with: "+"),
                          "limit": String(ITunesParameters.limitOfItem),
                          "offset": String(offset)]
        return parameters
    }
}


