import Foundation

struct ITunesURLElements {
    static let baseURL = "https://itunes.apple.com/"
    static let searchPath = "search"
}

struct GitHubUrlElements {
    static let baseURL = "https://api.github.com/"
    static let searchUserPath = "search/users"
}

class NetworkManger: RequestProtocol {
    
    //MARK: - Singletone propertie
    static let shared = NetworkManger()
    
    //MARK: - Private properties
    private lazy var session = URLSession(configuration: .default)
    private lazy var parameters: [String: String] = [:]
    
    //MARK: - Initialization
    private init() {}
    
    //MARK: - Public methods
    func request<T: Decodable>(baseURL: String,
                               url: String,
                               parameters: [String: String]? = nil,
                               completionHandler: @escaping (T) -> Void,
                               errorHandler: @escaping (RequestError) -> Void) {
        var urlParameters = self.parameters
        if let parameters = parameters {
            for parameter in parameters {
                urlParameters[parameter.key] = parameter.value
            }
        }
        guard let fullUrl = self.getUrlWith(
            url: baseURL,
            path: url,
            params: urlParameters) else {
                errorHandler(.incorrectUrl)
                return
        }
        let request = URLRequest(url: fullUrl)
        let dataTask = self.session.dataTask(with: request, completionHandler: { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    errorHandler(.networkError(error: error))
                }
                return
            }
            if let data = data,
                let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200...299:
                    do {
                        let data = try JSONDecoder().decode(T.self, from: data)
                        completionHandler(data)
                    } catch let error {
                        DispatchQueue.main.async {
                            errorHandler(.parsingError(error: error))
                        }
                    }
                case 401, 404:
                    break
                default:
                    DispatchQueue.main.async {
                        errorHandler(.serverError(statusCode: response.statusCode))
                    }
                }
            }
        })
        dataTask.resume()
    }
}
