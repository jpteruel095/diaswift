//
//  RGMViewDelegate.swift
//  rgmlib-example
//
//  Created by John Patrick Teruel on 1/14/21.
//

import UIKit

protocol RGMViewDelegate {
    
}

// MARK: UI Alert Controller extensions
extension RGMViewDelegate where Self: UIViewController{
    func showMessageAlert(title: String?,
                          message: String?,
                          actions: [UIAlertAction] = [],
                          completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: title,
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showErrorMessageAlert(message: String,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Error",
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showErrorMessageAlert(error: Error,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil){
        self.showErrorMessageAlert(message: error.localizedDescription,
                                   actions: actions,
                                   completion: completion)
    }
    
    func willShowErrorMessageAlert(error: Error?,
                               actions: [UIAlertAction] = [],
                               completion: (() -> Void)? = nil) -> Bool{
        guard let error = error else{
            return false
        }
        self.showErrorMessageAlert(message: error.localizedDescription,
                                   actions: actions,
                                   completion: completion)
        return true
    }
    
    func showInvalidInputMessageAlert(message: String,
                                      actions: [UIAlertAction] = [],
                                      completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Invalid",
                                     message: message,
                                     actions: actions,
                                     completion: completion)
    }
    
    func showNoInternetConnectionMessageAlert(sender: UIViewController? = nil,
                                              actions: [UIAlertAction] = [],
                                              completion: (() -> Void)? = nil){
        Helpers.showMessageAlertView(viewController: self,
                                     title: "Error",
                                     message: "Your device is currently offline. Please check your Internet connection and try again.",
                                     actions: actions,
                                     completion: completion)
    }
    
    func showActionSheet(title: String?,
                         actions: [UIAlertAction],
                         popoverSourceView: UIView? = nil,
                         completion: (() -> Void)? = nil){
        Helpers.showActionSheet(viewController: self,
                                title: title,
                                actions: actions,
                                popoverSourceView: popoverSourceView,
                                completion: completion)
    }
    
    func present(viewController: UIViewController,
              inNavigation shouldShowInNavigation: Bool = false,
              transparentBar: Bool = false,
              modalPresentationStyle: UIModalPresentationStyle = .fullScreen){
        if shouldShowInNavigation{
            let navVC = UINavigationController(rootViewController: viewController)
            navVC.modalPresentationStyle = modalPresentationStyle
            navVC.navigationBar.barTintColor = .white
            if transparentBar{
                navVC.navigationBar.shadowImage = UIImage()
            }
            self.present(navVC, animated: true, completion: nil)
        }else{
            viewController.modalPresentationStyle = modalPresentationStyle
            self.present(viewController, animated: true, completion: nil)
        }
    }
}
