import UIKit

extension UIViewController {
  
  func shouldHideKeyboardWhenTappedAnyArea() {
    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
    tap.cancelsTouchesInView = false
    view.addGestureRecognizer(tap)
  }

  @objc func hideKeyboard() {
    view.endEditing(true)
  }
}
