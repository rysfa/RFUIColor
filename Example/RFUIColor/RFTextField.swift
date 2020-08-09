//
//  RFTextField.swift
//  RFUIColor_Example
//
//  Created by Richard Fa on 2020-08-09.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit

protocol RFTextFieldDelegate: AnyObject {
    func textField(_ textField: RFTextField, updateColorTo color: UIColor)
}

class RFTextField: UITextField {

    weak var rfDelegate: RFTextFieldDelegate?

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        delegate = self
    }
}

extension RFTextField: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        var newText = string.uppercased()
        if let text = textField.text as NSString? {
            newText = text.replacingCharacters(in: range, with: string).uppercased()
        }

        if !newText.hasPrefix("#") {
            newText = "#\(newText)"
        }
        if newText.count > 7 {
            newText = String(newText.prefix(7))
        }


        if newText.containsValidHexValues {
            textField.text = newText
        }

        if let rfTextField = textField as? RFTextField, let color = newText.color {
            textColor = .darkText
            if newText.count == 7 {
                resignFirstResponder()
                rfDelegate?.textField(rfTextField, updateColorTo: color)
            }
        } else {
            textColor = .red
        }

        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        resignFirstResponder()
        if let rfTextField = textField as? RFTextField, let color = textField.text?.color {
            rfDelegate?.textField(rfTextField, updateColorTo: color)
        }
        return true
    }
}
