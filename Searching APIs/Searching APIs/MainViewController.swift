import UIKit

enum SelectedSearchingSegment: Int {
    case iTunes = 0
    case gitHub = 1
}

class MainViewController: UIViewController {

    //MARK: - @IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    

    //MARK: - Private properties
    private var selectedSegment: Int {
        return self.segmentControl.selectedSegmentIndex
    }
    
    private var itunesdata: [Result] = []
    private var github: [Result] = []
    private var a: [Result] = []
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
      //  self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let evenCellNib = UINib(nibName: EvenTableCell.nibName, bundle: nil)
        self.tableView.register(evenCellNib, forCellReuseIdentifier: EvenTableCell.nibName)
        let oddCellNib = UINib(nibName: OddTableCell.nibName, bundle: nil)
        self.tableView.register(oddCellNib, forCellReuseIdentifier: OddTableCell.nibName)
        self.tableView.dataSource = self
        self.searchBar.delegate = self
        self.tableView.rowHeight = 150
        
    }

    //MARK: - Actions
    @IBAction func segmentIndexChanged(_ sender: UISegmentedControl) {
        self.tableView.reloadData()
    }
     var isFirstRequest: Bool = true
    
}

//MARK: - UITableViewDataSource
extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if let selectedSegment = SelectedSearchingSegment.init(rawValue: self.selectedSegment) {
//            switch selectedSegment {
//            case .iTunes:
//                self.a = self.itunesdata
//                return self.itunesdata.count
//            case .gitHub:
//                self.a = self.github
//                return self.github.count
//            }
//        } else {
//            return 0
//        }
   
            return self.a.count
 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: EvenTableCell.cellID) as? EvenTableCell else {
            return UITableViewCell()
        }
        guard let oddCell = tableView.dequeueReusableCell(withIdentifier: OddTableCell.cellID) as? OddTableCell else {
            return UITableViewCell()
        }
        if indexPath.row == 0 || indexPath.row % 2 == 0 {
            cell.titleLabel.text = self.a[indexPath.row].artistName
            cell.subTitleLabel.text = self.a[indexPath.row].trackName
            
            if  let url = URL(string: self.a[indexPath.row].artworkUrl100) {
                cell.icon.load(with: url )
            }
            return cell
        } else {
            oddCell.titleLabel.text = self.a[indexPath.row].artistName
            oddCell.subTitleLabel.text = self.a[indexPath.row].trackName
            
            if  let url = URL(string: self.a[indexPath.row].artworkUrl100) {
                oddCell.icon.load(with: url )
            }
            return oddCell
        }
        
    }
    

    
   
}

extension MainViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let parameters = ["term": searchText.replacingOccurrences(of: " ", with: "+")]
        
        ITunesSarchManager.shared.request(
            url: ITunesURLPaths.search,
            parameters: parameters,
            completionHandler: { (list: InfoModel) in
                var indexPathes: [IndexPath] = []
                self.a = list.results
                for (index,_) in self.a.enumerated() {
                    indexPathes.append(IndexPath(row: index, section: 0))
                }
                
                DispatchQueue.main.async {
                    
                    
                    self.tableView.reloadData()
                    if let indexPaths = self.tableView.indexPathsForVisibleRows {
                        self.tableView.reloadRows(at: indexPaths, with: .top)
                    }
                    
                }
                //print(list.results.count)
        }, errorHandler: { (error) in
            print(error)
        })
    }
    
   
 
}
