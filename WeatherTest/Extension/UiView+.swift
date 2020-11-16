import UIKit

extension UIView {
  
  func applyShadowConner() {
    backgroundColor = .white
    layer.cornerRadius = 10.0
    layer.shadowColor = UIColor.gray.cgColor
    layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
    layer.shadowRadius = 10.0
    layer.shadowOpacity = 0.7
  }
}
