import UIKit
import RealmSwift

class AddMoney: UIViewController {

    var isIncome: Bool = true
    @IBOutlet weak var moneyNameTextField: UITextField!
    @IBOutlet weak var moneyAmountTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var addMoneyButtonOutlet: UIButton!
    @IBOutlet weak var switchHeight: NSLayoutConstraint!
    @IBOutlet weak var switchBtn: UISwitch!
    
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    func setupView() {
        if isIncome {
            self.moneyNameTextField.placeholder = "Insert Income name e.g: Rent"
            self.moneyAmountTextField.placeholder = "Insert Income amount e.g: £500"
            self.addMoneyButtonOutlet.setTitle("Add Income", for: .normal)
            self.switchHeight.constant = 0
        } else {
            self.switchHeight.constant = 35
            self.moneyNameTextField.placeholder = "Insert Expense name e.g: Rent"
            self.moneyAmountTextField.placeholder = "Insert Expense amount e.g: £500"
            self.addMoneyButtonOutlet.setTitle("Add Expense", for: .normal)
        }
    }
    
    @IBAction func addMoneyBtnPressed(_ sender: UIButton) {
        let transaction = Transaction()
        transaction.ammount = Int(moneyAmountTextField.text!)!
        transaction.name = moneyNameTextField.text ?? ""
        transaction.date = datePicker.date
        if isIncome {
            transaction.isIncome = true
            transaction.isPaid = true
        } else {
            transaction.isIncome = false
            if switchBtn.isOn {
                transaction.isPaid = true
            } else {
                transaction.isPaid = false
            }
        }
        realm.beginWrite()
        realm.add(transaction)
        try! realm.commitWrite()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func switchBtnPressed(_ sender: UISwitch) {
    }
}

class Transaction: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var ammount: Int = 0
    @objc dynamic var isIncome: Bool = false
    @objc dynamic var date: Date? = nil
    @objc dynamic var isPaid: Bool = false
}
