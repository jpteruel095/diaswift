//
//  UIAlertActionExt.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 2/3/21.
//

import UIKit

extension UIAlertAction{
    static func cancelButton(with text: String = "Cancel", handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertAction{
        return UIAlertAction(title: text,
                             style: .cancel,
                             handler: handler)
    }
}
