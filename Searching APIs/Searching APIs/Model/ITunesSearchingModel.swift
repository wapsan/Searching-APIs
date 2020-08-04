import Foundation

struct ITunesSearchingModel: Decodable {
    var results: [Result]
}

struct Result: Decodable {
    private let artistName: String
    private let trackName: String
    private let artworkUrl100: String
}

//MARK: - PresentingModel
extension Result: PresentingModel {
    
    var titleText: String {
        return self.artistName
    }
    
    var subtitleText: String {
        return self.trackName
    }
    
    var iconURL: String {
        return self.artworkUrl100
    }
}
