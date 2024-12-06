import UIKit
import BraintreeCard

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let cardFormStackView: CustomStackView = {
        let view = CustomStackView()
        view.axis = .vertical
        return view
    }()
    
    let expirationCVVStackView: CustomStackView = {
        let view = CustomStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    let submitHistoryStackView: CustomStackView = {
        let view = CustomStackView()
        view.axis = .horizontal
        view.alignment = .center
        view.distribution = .fillEqually
        return view
    }()
    
    lazy var creditCardNumberTextField: CustomTextField = {
        let textField = CustomTextField(placeholderText: "Credit Card Number")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var cvvTextField: CustomTextField = {
        let textField = CustomTextField(placeholderText: "CVV")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    lazy var expirationDateTextField = CustomTextField(placeholderText: "Exp. Date")
    
    lazy var historyButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("History", for: .normal)
        button.addTarget(self, action: #selector(historyTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var submitButton: CustomButton = {
        let button = CustomButton()
        button.setTitle("Submit", for: .normal)
        button.addTarget(self, action: #selector(submitTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var transactionAmountTextField: CustomTextField = {
        let textField = CustomTextField(placeholderText: "Amount")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    var clientToken: String? = nil
    var expDateArray = [String]()
    
    //    MARK: - UIViewController Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        title = "Checkout"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "B_Proportional-Bold", size: 22)!]
        
        setupSubviews()
        setupConstraints()
        fetchClientToken()
    }
    
    //    MARK: - Configure Views
    
    func setupSubviews() {
        expirationCVVStackView.addArrangedSubview(expirationDateTextField)
        expirationCVVStackView.addArrangedSubview(cvvTextField)
        
        submitHistoryStackView.addArrangedSubview(submitButton)
        submitHistoryStackView.addArrangedSubview(historyButton)
        
        cardFormStackView.addArrangedSubview(transactionAmountTextField)
        cardFormStackView.addArrangedSubview(creditCardNumberTextField)
        cardFormStackView.addArrangedSubview(expirationCVVStackView)
        cardFormStackView.addArrangedSubview(submitHistoryStackView)
        
        view.addSubview(cardFormStackView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            cardFormStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            cardFormStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardFormStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            creditCardNumberTextField.heightAnchor.constraint(equalToConstant: 40),
            expirationDateTextField.heightAnchor.constraint(equalToConstant: 40),
            transactionAmountTextField.heightAnchor.constraint(equalToConstant: 40),
            cvvTextField.heightAnchor.constraint(equalToConstant: 40),
            submitButton.heightAnchor.constraint(equalToConstant: 40),
            historyButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    //    MARK: - Button Actions
    
    @objc func submitTapped() {
        view.endEditing(true)
        
        guard let clientToken else {
            let error = ViewControllerError.optionalUnwrapFailed("clientToken")
            show(message: error.description)
            return
        }
        
        guard let apiClient = BTAPIClient(authorization: clientToken) else {
            let error = ViewControllerError.invalidBTAPIClient
            show(message: error.description)
            return
        }
        
        let cardClient = BTCardClient(apiClient: apiClient)
        let card = BTCard()
        
        expDateArray = (expirationDateTextField.text?.components(separatedBy: "/"))!
        
        card.number = creditCardNumberTextField.text
        card.expirationMonth = expDateArray[0]
        card.expirationYear = expDateArray[1]
        card.cvv = cvvTextField.text
        card.shouldValidate = true
        
        cardClient.tokenizeCard(card) { nonce, error in
            if let error {
                let error = ViewControllerError.failedTokenization(error)
                self.show(message: error.description)
            }
            
            guard let nonce else {
                let error = ViewControllerError.optionalUnwrapFailed("nonce")
                self.show(message: error.description)
                return
            }
            
            self.createTransaction(nonce: nonce.nonce, amount: self.transactionAmountTextField.text ?? "0")
            
            self.transactionAmountTextField.text?.removeAll()
            self.creditCardNumberTextField.text?.removeAll()
            self.expirationDateTextField.text?.removeAll()
            self.cvvTextField.text?.removeAll()
        }
    }
    
    @objc func historyTapped() {
        view.endEditing(true)
        
        transactionAmountTextField.text?.removeAll()
        creditCardNumberTextField.text?.removeAll()
        expirationDateTextField.text?.removeAll()
        cvvTextField.text?.removeAll()
        
        let vc = HistoryTableView()
        let sender = ViewController()
        show(vc, sender: sender)
    }
    
    //    MARK: - Internal Functions
    
    func fetchClientToken() {
        guard let clientTokenURL = URL(string: "http://localhost:8000/Server/client_token.php") else {
            let error = ViewControllerError.invalidFormat("clientTokenURL")
            show(message: error.description)
            return
        }
        
        let clientTokenRequest = URLRequest(url: clientTokenURL)
        
        URLSession.shared.dataTask(with: clientTokenRequest) { data, response, error in
            if let error {
                let error = ViewControllerError.clientTokenNotFound(error)
                self.show(message: error.description)
                return
            }
            
            guard let data else {
                let error = ViewControllerError.dataNotFound("clientToken")
                self.show(message: error.description)
                return
            }
            
            guard let clientToken = String(data: data, encoding: .utf8) else {
                let error = ViewControllerError.invalidFormat("clientToken")
                self.show(message: error.description)
                return
            }
            
            self.clientToken = clientToken
        }
        .resume()
    }
    
    func createTransaction(nonce: String, amount: String) {
        guard let createTransactionURL = URL(string: "http://localhost:8000/Server/create_transaction.php") else {
            let error = ViewControllerError.invalidFormat("createTransactionURL")
            show(message: error.description)
            return
        }
        
        var createTransactionURLRequest = URLRequest(url: createTransactionURL)
        createTransactionURLRequest.httpBody = "payment_method_nonce=\(nonce)&amount=\(amount)".data(using: .utf8)
        createTransactionURLRequest.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: createTransactionURLRequest) { data, response, error in
            if let error {
                let error = ViewControllerError.createTransactionFailed(error)
                self.show(message: error.description)
                return
            }
            
            guard let data else {
                let error = ViewControllerError.dataNotFound("Transaction")
                self.show(message: error.description)
                return
            }
            
            guard let result = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let success = result["success"] as? Bool,
                  success == true
            else {
                let error = ViewControllerError.jsonSerializationFailure
                self.show(message: error.description)
                return
            }
            self.show(message: "Transaction successful!")
        }
        .resume()
    }
    
    func show(message: String) {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: message, message: nil, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
            self.present(alertController, animated: true)
        }
    }
}
