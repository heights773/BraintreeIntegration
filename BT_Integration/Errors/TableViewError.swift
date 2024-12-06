import Foundation

enum TableViewError: Error, CustomStringConvertible {
    case invalidTransactionSearchURL
    case transactionSearchFailed(Error)
    case dataNotFound
    
    var description: String {
        switch self {
        case .invalidTransactionSearchURL:
            return "Failure to format transaction search URL."
            
        case .transactionSearchFailed(let error):
            return "Error executing transaction search: \(error.localizedDescription)"
            
        case .dataNotFound:
            return "Failure to retrieve data. Make sure you start your server using the instructions in the README"
        }
    }
}
