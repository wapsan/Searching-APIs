import Foundation

struct InfoModel: Decodable {
    
    var results: [Result]
    
}

struct Result: Decodable {
    var artistName: String
    var trackName: String
    var artworkUrl100: String
}
