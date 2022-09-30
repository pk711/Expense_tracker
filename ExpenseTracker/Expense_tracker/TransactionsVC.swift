import UIKit
import RealmSwift

class TransactionsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sortByView: UIView!
    
    var transaction = [Transaction]()
    let realm = try! Realm()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Transactions"
        setupTableView()
    }
    
    @IBAction func sortByButtonPressed(_ sender: UIButton) {
        self.sortByView.isHidden = false
        print("Sort")
    }
    
    @IBAction func sortBtnSelectionPressed(_ sender: UIButton) {
        switch sender.tag {
        case 0:
            self.transaction = transaction.sorted(by: { $0.ammount < $1.ammount })
        case 1:
            self.transaction = transaction.sorted(by: { $0.ammount > $1.ammount })
        case 2:
            self.transaction = transaction.sorted(by: { $0.date! > $1.date! })
        case 3:
            self.transaction = transaction.sorted(by: { $0.date! < $1.date! })
        default:
            break
        }
        self.sortByView.isHidden = true
        self.tableView.reloadData()
    }
}

extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "recentTransactionsCell", bundle: nil), forCellReuseIdentifier: "recentTransactionsCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return transaction.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentTransactionsCell", for: indexPath) as! recentTransactionsCell
        cell.isFromHome = false
        cell.configure(object: transaction[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            realmDelete(index: indexPath.row)
            transaction.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    func realmDelete(index: Int) {
        
        do {
            let realm = try Realm()
            try! realm.write {
                realm.delete(transaction[index])
            }
        } catch let error as NSError {
            // handle error
            print("error - \(error.localizedDescription)")
        }
    }
}

extension TransactionsVC: RecentTransactionCellDelegate {
    func markAsPaid(cell: UITableViewCell) {
        guard let indexPath = self.tableView.indexPath(for: cell) else { return }
        let transaction = self.transaction[indexPath.row]
        try! realm.write {
            transaction.isPaid = true
            }
        self.tableView.reloadData()
    }
}
