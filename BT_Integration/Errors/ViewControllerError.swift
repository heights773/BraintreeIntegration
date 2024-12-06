import Foundation

enum ViewControllerError: Error, CustomStringConvertible {
    case createTransactionFailed(Error)
    case invalidBTAPIClient
    case failedTokenization(Error)
    case optionalUnwrapFailed(String)
    case invalidFormat(String)
    case clientTokenNotFound(Error)
    case dataNotFound(String)
    case jsonSerializationFailure
    
    var description: String {
        switch self {
        case .createTransactionFailed(let error):
            return "Error creating transaction: \(error.localizedDescription)"
            
        case .optionalUnwrapFailed(let type):
            return "Failure to unwrap \(type)."
            
        case .invalidBTAPIClient:
            return "The BTAPIClient was invalid or missing."
            
        case .failedTokenization(let error):
            return "Error tokenizing card: \(error.localizedDescription)"
            
        case .invalidFormat(let type):
            return "Failure to format \(type)."
            
        case .clientTokenNotFound(let error):
            return "Error fetching client token: \(error.localizedDescription)"
            
        case .dataNotFound(let type):
            return "Failure to retrieve data: \(type). Make sure you start your server using the instructions in the README"
            
        case .jsonSerializationFailure:
            return "The request could not be serialized."
        }
    }
}

