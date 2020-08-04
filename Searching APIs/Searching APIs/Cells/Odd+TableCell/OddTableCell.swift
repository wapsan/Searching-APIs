import UIKit

class OddTableCell: UITableViewCell {

    static let nibName = "OddTableCell"
    static let cellID = "OddTableCell"
    
    //MARK: - @IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    //MARK: - Setter
    func setCell(for presentingModel: PresentingModel) {
        self.titleLabel.text = presentingModel.titleText
        self.subTitleLabel.text = presentingModel.subtitleText      
        if let iconURL = URL(string: presentingModel.iconURL) {
            self.icon.loadImage(with: iconURL)
        }
    }
    
    //MARK: - Public methdos
    override func prepareForReuse() {
        super.prepareForReuse()
        self.icon.image = nil
        self.titleLabel.text = nil
        self.subTitleLabel.text = nil
    }
}
