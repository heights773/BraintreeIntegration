import UIKit

class CustomStackView: UIStackView {
    convenience init() {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        spacing = 5
    }
}
