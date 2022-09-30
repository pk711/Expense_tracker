import UIKit
import RKPieChart
import RealmSwift

class OverViewVC: UIViewController {


    @IBOutlet weak var balanceLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var overView: UIView!
    
    var isIncome: Bool = true
    let realm = try! Realm()
    var transaction = [Transaction]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retriveData()
       setupTableView()
        let addIncoome = UIBarButtonItem(title: "Add Income", style: .done, target: self, action: #selector(addIncome))
        let addExpense = UIBarButtonItem(title: "Add Expense", style: .done, target: self, action: #selector(addExpense))
        self.navigationItem.rightBarButtonItem  = addIncoome
        self.navigationItem.leftBarButtonItem  = addExpense
        setupChartView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        retriveData()
    }
    
    func retriveData() {
        self.transaction.removeAll()
        let transaction = realm.objects(Transaction.self)
        for i in transaction {
            self.transaction.insert(i, at: 0)
        }
        getBalance()
        self.tableView.reloadData()
        self.setupChartView()
        print(self.transaction)
    }
    
    func getBalance() {
        var balance = 0
        for i in transaction {
            if i.isIncome {
                balance += i.ammount
            } else {
                if i.isPaid {
                    balance -= i.ammount
                }
            }
        }
        self.balanceLabel.text = "£\(balance)"
        if balance < 0 {
            self.balanceLabel.textColor = .systemRed
        } else {
            self.balanceLabel.textColor = .black
        }
    }
    
    func setupChartView() {
        var total: Double = 0
        var income: Double = 0
        var expense: Double = 0
        for i in transaction {
            total += Double(i.ammount)
            if i.isIncome {
                income += Double(i.ammount)
            } else {
                if i.isPaid {
                    expense += Double(i.ammount)
                }
            }
        }
        
        income = income * 100
        expense = expense * 100
        print(total, income, expense, "total")
        let incomePerc = round(income / total)
        let expensePerc = round(expense / total)
        print(incomePerc, expensePerc)
        
        var firstItem: RKPieChartItem!
        var secondItem: RKPieChartItem!
        
        if transaction.count == 0 {
            firstItem = RKPieChartItem(ratio: 0, color: UIColor.systemGray, title: "Income (0%)")
            secondItem = RKPieChartItem(ratio: 0, color: UIColor.systemGray4, title: "Expense (0%)")
        } else {
            firstItem = RKPieChartItem(ratio: uint(incomePerc), color: UIColor.systemGray, title: "Income (\(incomePerc)%)")
            secondItem = RKPieChartItem(ratio: uint(expensePerc), color: UIColor.systemGray4, title: "Expense (\(expensePerc)%)")
        }
        

        let itemsArray: [RKPieChartItem] = [firstItem, secondItem]
        let chartView = RKPieChartView(items: itemsArray, centerTitle: "Balance")
        chartView.circleColor = .clear
        chartView.translatesAutoresizingMaskIntoConstraints = false
        chartView.arcWidth = 40
        chartView.isIntensityActivated = false
        chartView.style = .butt
        chartView.isTitleViewHidden = false
        chartView.isAnimationActivated = true
        self.view.addSubview(chartView)
        
        chartView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        chartView.centerXAnchor.constraint(equalTo: self.overView.centerXAnchor).isActive = true

        let verticalSpace = NSLayoutConstraint(item: chartView, attribute: .top, relatedBy: .equal, toItem: self.balanceLabel, attribute: .bottom, multiplier: 1, constant: 20)

        NSLayoutConstraint.activate([verticalSpace])
    }

    @IBAction func seeAllButtonPressed(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TransactionsVC") as! TransactionsVC
        vc.transaction = self.transaction
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addIncome() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMoney") as! AddMoney
        vc.isIncome = true
        vc.title = "Add New Income"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addExpense() {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddMoney") as! AddMoney
        vc.isIncome = false
        vc.title = "Add New Expense"
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension OverViewVC: UITableViewDelegate, UITableViewDataSource {
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "recentTransactionsCell", bundle: nil), forCellReuseIdentifier: "recentTransactionsCell")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.transaction.count > 3 {
            return 3
        } else {
            return transaction.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "recentTransactionsCell", for: indexPath) as! recentTransactionsCell
        cell.isFromHome = true
        cell.configure(object: self.transaction[indexPath.item])
        print(self.transaction[indexPath.item].isPaid, indexPath.item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    
}

