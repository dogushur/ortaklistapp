/**
 *  BulletinBoard
 *  Copyright (c) 2017 - present Alexis Aubry. Licensed under the MIT license.
 */

import UIKit
import BLTNBoard

/**
 * An item that displays a text field.
 *
 * This item demonstrates how to create a bulletin item with a text field and how it will behave
 * when the keyboard is visible.
 */

class TextFieldBulletinPage: FeedbackPageBLTNItem {

    @objc public var textField: UITextField!

    @objc public var textInputHandler: ((BLTNActionItem, String?) -> Void)? = nil
    
    override func makeViewsUnderDescription(with interfaceBuilder: BLTNInterfaceBuilder) -> [UIView]? {
        textField = interfaceBuilder.makeTextField(returnKey: .done, delegate: self)
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        
        let inputplaceholder = [
            NSAttributedString.Key.foregroundColor: UIColor("#555"),
            //NSAttributedString.Key.font : UIFont(name: "Ubuntu-Medium", size: 25)!
        ]
        
        textField.attributedPlaceholder = NSAttributedString(string: "Liste Başlığı", attributes:inputplaceholder)
        textField.keyboardType = .default
        textField.keyboardAppearance = .dark
        textField.textColor = UIColor("#555")
        textField.font = UIFont.systemFont(ofSize: 25)
        
        return [textField]
    }
    

    override func tearDown() {
        super.tearDown()
        textField?.delegate = nil
    }

    override func actionButtonTapped(sender: UIButton) {
        textField.resignFirstResponder()
        super.actionButtonTapped(sender: sender)
    }
    
}

// MARK: - UITextFieldDelegate

extension TextFieldBulletinPage: UITextFieldDelegate {
    
    @objc open func isInputValid(text: String?) -> Bool {

        if text == nil || text!.isEmpty {
            return false
        }

        return true

    }

    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {

        if isInputValid(text: textField.text) {
            textInputHandler?(self, textField.text)
        } else {
            /*descriptionLabel!.textColor = .red
            descriptionLabel!.text = "You must enter some text to continue."
            textField.backgroundColor = UIColor.red.withAlphaComponent(0.3)*/
        }

    }

}
