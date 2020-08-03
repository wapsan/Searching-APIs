import UIKit

class OddTableCell: UITableViewCell {

    static let nibName = "OddTableCell"
    static let cellID = "OddTableCell"
    
    //MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
