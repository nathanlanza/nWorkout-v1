import UIKit

class RowCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        textField.isEnabled = false
        return true
    }
}