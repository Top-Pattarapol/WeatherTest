import UIKit

extension UIView {
  
  func applyShadowConner() {
    layer.cornerRadius = 6.0
    layer.masksToBounds = true
    // set the shadow properties
    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 1.0)
    layer.shadowOpacity = 0.2
    layer.shadowRadius = 4.0
  }
}
