import UIKit

class CustomTextField: UITextField {
    convenience init(placeholderText: String? = nil) {
        self.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        placeholder = placeholderText
        font = UIFont(name: "B_Proportional-Bold", size: 18)
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
    }
}

