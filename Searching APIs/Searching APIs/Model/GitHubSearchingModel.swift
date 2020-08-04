import Foundation

struct GitHubSearchingModel: Decodable {
    let items: [Item]
}

struct Item: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case login
        case avatarURL = "avatar_url"
        case htmlURL = "html_url"
    }
    
    private let login: String
    private let avatarURL: String
    private let htmlURL: String
}

//MARK: - PresentingModel
extension Item: PresentingModel {

    var titleText: String {
        return self.login
    }
    
    var subtitleText: String {
        return self.htmlURL
    }
    
    var iconURL: String {
        return self.avatarURL
    }
}
