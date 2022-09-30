import UIKit

protocol RecentTransactionCellDelegate: AnyObject {
    func markAsPaid(cell: UITableViewCell)
}

class recentTransactionsCell: UITableViewCell {

    @IBOutlet weak var transactionNameLabel: UILabel!
    @IBOutlet weak var transactionAmountLabel: UILabel!
    @IBOutlet weak var transactionDateLabel: UILabel!
    @IBOutlet weak var markAsPaidBtn: UIButton!
    
    var isFromHome: Bool = true
    weak var delegate: RecentTransactionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure(object: Transaction) {
        self.transactionNameLabel.text = object.name
        if object.isIncome {
            self.transactionAmountLabel.textColor = .systemGreen
            self.transactionAmountLabel.text = "+ £\(object.ammount)"
            contentView.backgroundColor = .white
        } else {
            self.transactionAmountLabel.textColor = .systemRed
            self.transactionAmountLabel.text = "- £\(object.ammount)"
            if object.isPaid {
                contentView.backgroundColor = .white
            } else {
                contentView.backgroundColor = .gray
            }
        }
        if isFromHome == false {
            if object.isPaid == false {
                self.markAsPaidBtn.isHidden = false
            } else {
                self.markAsPaidBtn.isHidden = true
            }
        } else {
            self.markAsPaidBtn.isHidden = true
        }
        self.transactionDateLabel.text = object.date?.formatted()
    }

    @IBAction func markAsPaidBtnPressed(_ sender: UIButton) {
        delegate?.markAsPaid(cell: self)
    }
    
    
}
