import UIKit

class CustomButton: UIButton {
    convenience init() {
        self.init(frame: .zero)
        
        layer.borderWidth = 0.5
        layer.borderColor = UIColor.lightGray.cgColor
        layer.cornerRadius = 5
        translatesAutoresizingMaskIntoConstraints = false
        setTitleColor(UIColor.white, for: .normal)
        backgroundColor = .systemGray
        titleLabel?.font = UIFont(name: "B_Proportional-Bold", size: 20)
    }
}
