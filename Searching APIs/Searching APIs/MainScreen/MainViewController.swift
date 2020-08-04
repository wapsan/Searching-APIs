import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Searching servise enumeration
    enum SearchingServise: Int {
        case iTunes = 0
        case gitHub = 1
    }
    
    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    //MARK: - Private properties
    private lazy var searchingText: String = ""
    private lazy var itunesOffsetCount = 0
    private lazy var gitHubPage = 1
    private lazy var tableRowHeight: CGFloat = 150.0
    private lazy var searhedItemList: [PresentingModel] = []
    
    private var searchingServise: SearchingServise? {
        return SearchingServise.init(rawValue: self.segmentControl.selectedSegmentIndex)
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpTableView()
        self.searchBar.delegate = self
        
    }
    
    //MARK: - Private methods
    private func setUpTableView() {
        let evenCellNib = UINib(nibName: EvenTableCell.nibName, bundle: nil)
        self.tableView.register(evenCellNib, forCellReuseIdentifier: EvenTableCell.nibName)
        
        let oddCellNib = UINib(nibName: OddTableCell.nibName, bundle: nil)
        self.tableView.register(oddCellNib, forCellReuseIdentifier: OddTableCell.nibName)
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = self.tableRowHeight
    }
    
    private func updateTable(with searchText: String) {
        if searchText.isEmpty {
            self.searhedItemList = []
            self.tableView.reloadData()
            return
        }
        guard let lastCharacter = searchText.last,
            lastCharacter != " " else { return }
        self.searchingText = searchText
        let iTunesParameters = ITunesParameters.createParameter(with: searchText)
        let gitHubParameters = GitHubParameters.createParameters(with: searchText)
        guard let searchingServise = self.searchingServise else { return }
        switch searchingServise {
        case .iTunes:
            NetworkManger.shared.request(
                baseURL: ITunesURLElements.baseURL,
                url: ITunesURLElements.searchPath,
                parameters: iTunesParameters,
                completionHandler: { [weak self] (list: ITunesSearchingModel) in
                    guard let self = self else { return }
                    self.searhedItemList = list.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if let indexPaths = self.tableView.indexPathsForVisibleRows {
                            self.tableView.reloadRows(at: indexPaths, with: .top)
                        }
                    }
                }, errorHandler: { (error) in
                    print(error)
            })
        case .gitHub:
            NetworkManger.shared.request(
                baseURL: GitHubUrlElements.baseURL,
                url: GitHubUrlElements.searchUserPath,
                parameters: gitHubParameters,
                completionHandler: { [weak self] (model: GitHubSearchingModel) in
                    guard let self = self else { return }
                    self.searhedItemList = model.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if let indexPaths = self.tableView.indexPathsForVisibleRows {
                            self.tableView.reloadRows(at: indexPaths, with: .top)
                        }
                    }
                }, errorHandler: { (error) in
                    print(error)
            })
        }
    }
    
    func loadMoreItems() {
        guard let searchingService = self.searchingServise else { return }
        switch searchingService {
        case .iTunes:
            self.itunesOffsetCount += ITunesParameters.limitOfItem
            let iTunesReloadParameters = ITunesParameters.createParameter(with: self.searchingText,
                                                                          and: self.itunesOffsetCount)
            NetworkManger.shared.request(
                baseURL: ITunesURLElements.baseURL,
                url: ITunesURLElements.searchPath,
                parameters: iTunesReloadParameters,
                completionHandler: { [weak self] (list: ITunesSearchingModel) in
                    guard let self = self else { return }
                    self.searhedItemList += list.results
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }, errorHandler: { (error) in
                    print(error)
            })
        case .gitHub:
            self.gitHubPage += 1
            let gitHubReloadParameters = GitHubParameters.createParameters(with: self.searchingText,
                                                                           and: self.gitHubPage)
            NetworkManger.shared.request(
                baseURL: GitHubUrlElements.baseURL,
                url: GitHubUrlElements.searchUserPath,
                parameters: gitHubReloadParameters,
                completionHandler: { [weak self] (model: GitHubSearchingModel) in
                    guard let self = self else { return }
                    self.searhedItemList += model.items
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }, errorHandler: { (error) in
                    print(error)
            })
        }
    }
    
    //MARK: - Actions
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        guard let searchingServise = self.searchingServise else { return }
        switch searchingServise {
        case .iTunes:
            self.gitHubPage = 0
            self.itunesOffsetCount = ITunesParameters.limitOfItem
        case .gitHub:
            self.gitHubPage = 1
            self.itunesOffsetCount = 0
        }
        self.searchingText = ""
        self.searchBar.text = nil
        self.searhedItemList = []
        self.tableView.reloadData()
    }
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searhedItemList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let searchedItem = self.searhedItemList[indexPath.row]
        guard let evenCell = tableView.dequeueReusableCell(withIdentifier: EvenTableCell.cellID) as? EvenTableCell else {
            return UITableViewCell()
        }
        guard let oddCell = tableView.dequeueReusableCell(withIdentifier: OddTableCell.cellID) as? OddTableCell else {
            return UITableViewCell()
        }
        if indexPath.row % 2 != 0 {
            evenCell.setCell(for: searchedItem)
            return evenCell
        } else {
            oddCell.setCell(for: searchedItem)
            return oddCell
        }
    }
}

//MARK: - UITableViewDelegate
extension MainViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard self.searhedItemList.count > 5 else { return }
        let lastElement = self.searhedItemList.count - 5
        if indexPath.row == lastElement {
            self.loadMoreItems()
        }
    }
}

//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.updateTable(with: searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
