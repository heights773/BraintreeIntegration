import Foundation
import UIKit

class HistoryTableView: UITableViewController {
    
    //    MARK: - Internal Properties
    
    let baseViewController = ViewController()
    
    var total = 0
    var totalArray = [String?]()
    var transactions = [String?]()
    
    //    MARK: - UITableViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        title = "Total sales: $0.00"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "B_Proportional-Bold", size: 24)!]
        
        navigationController?.navigationBar.topItem?.backButtonDisplayMode = .minimal
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        transactionSearch()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = transactions[indexPath.row]
        cell.textLabel?.font = UIFont(name: "B_Proportional-Bold", size: 18)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        transactions.count
    }
    
    //    MARK: - Internal Functions
    
    func transactionSearch() {
        guard let transactionSearchURL = URL(string: "http://localhost:8000/Server/transaction_search.php") else {
            let error = TableViewError.invalidTransactionSearchURL
            baseViewController.show(message: error.description)
            return
        }
        
        let transactionSearchURLRequest = URLRequest(url: transactionSearchURL)
        
        URLSession.shared.dataTask(with: transactionSearchURLRequest) { data, response, error in
            if let error {
                let error = TableViewError.transactionSearchFailed(error)
                self.baseViewController.show(message: error.description)
                return
            }
            
            guard let data else {
                let error = TableViewError.dataNotFound
                self.baseViewController.show(message: error.description)
                return
            }
            
            let string = String(data: data, encoding: .utf8)!
            
            self.transactions = string.components(separatedBy: ",").dropLast()
            self.totalArray = self.transactions.map { $0?.components(separatedBy: "   $").last }
            self.updateDataSource(totalArray: self.totalArray)
        }
        .resume()
    }
    
    func addTransactions(transactionAmounts: [String?]) -> String {
        var total: Double = 0
        
        transactionAmounts.forEach { transaction in
            let transactionDouble = Double(transaction ?? "0")
            total += transactionDouble ?? 0
        }
        
        return String(format: "%.2f", total)
    }
    
    func updateDataSource(totalArray: [String?]){
        DispatchQueue.main.async {
            let total = self.addTransactions(transactionAmounts: totalArray)
            self.title = "Total sales: $\(total)"
            self.tableView.reloadData()
        }
    }
}
