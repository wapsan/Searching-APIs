import UIKit

class EvenTableCell: UITableViewCell {

    static let nibName = "EvenTableCell"
    static let cellID = "EvenTableCell"
    
    //MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

}
