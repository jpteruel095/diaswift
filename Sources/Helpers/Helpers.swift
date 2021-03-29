//
//  Helpers.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import UIKit
import SwiftyJSON

public struct Helpers{
    static func showMessageAlertView(viewController: UIViewController,
                                     title: String?,
                                     message: String?,
                                     actions: [UIAlertAction] = [],
                                     completion: (() -> Void)? = nil){
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if actions.count > 0{
            actions.forEach { (action) in
                alertView.addAction(action)
            }
        }else{
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let completion = completion {
                    completion()
                }
            }))
        }
        
        viewController.present(alertView, animated: true, completion: nil)
        
        var fullMessage = ""
        if let title = title{
            fullMessage += "\(title)\n"
        }
        if let message = message{
            fullMessage += message
        }
    }
    
    static func showActionSheet(viewController: UIViewController,
                                title: String?,
                                actions: [UIAlertAction],
                                popoverSourceView: UIView? = nil,
                                completion: (() -> Void)? = nil){
        let alertView = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        
        if actions.count > 0{
            actions.forEach { (action) in
                alertView.addAction(action)
            }
        }else{
            alertView.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                if let completion = completion {
                    completion()
                }
            }))
        }
        
        if let sourceView = popoverSourceView ?? viewController.view{
            alertView.popoverPresentationController?.sourceView = sourceView
            alertView.popoverPresentationController?.sourceRect = CGRect(origin: sourceView.center, size: .zero)
        }
        
        viewController.present(alertView, animated: true, completion: nil)
    }
    
    static func makeError(with description: String, code: Int = 0) -> Error{
        NSError(domain: Bundle.main.bundleIdentifier ?? "",
                code: code,
                userInfo: [NSLocalizedDescriptionKey: description])
    }
    
    static func makeOfflineError(code: Int = 0) -> Error{
        makeError(with: "You are currently offline.", code: code)
    }
    
    static func makeUserIDError(code: Int = 0) -> Error{
        makeError(with: "ID is not available on current user!", code: code)
    }
    
    static func makeTechnicalError(code: Int = 0) -> Error{
        makeError(with: "We are currently experiencing technical difficulties. Please try again later.", code: code)
    }
    
    static func loadJSONFromResource(named resourceName: String) -> JSON{
        guard let filePath = Bundle.main.url(forResource: resourceName, withExtension: "json"),
              let data = try? Data(contentsOf: filePath),
              let json = try? JSON(data: data) else {
            return JSON()
        }
        return json
    }
    
    static func loadJSONFromResourceAsync(named resourceName: String, completion: @escaping((JSON) -> Void)){
        DispatchQueue.global(qos: .background).async {
            guard let filePath = Bundle.main.url(forResource: resourceName, withExtension: "json"),
               let data = try? Data(contentsOf: filePath),
               let json = try? JSON(data: data) else {
                DispatchQueue.main.async {
                    completion(JSON())
                }
                return
            }
            
            DispatchQueue.main.async {
                completion(json)
            }
        }
    }
    
    static func getHTML(from file: String) -> String?{
        guard let filePath = Bundle.main.url(forResource: file, withExtension: "html"),
              let html = try? String(contentsOf: filePath) else{
            return nil
        }
        return html
    }
    
    static func getAttributedText(fromHTMLFile htmlFile: String) -> NSAttributedString?{
        guard let filePath = Bundle.main.url(forResource: htmlFile, withExtension: "html"),
              let html = try? String(contentsOf: filePath) else{
            return nil
        }
        
        let data = Data(html.utf8)
        guard let attr = try? NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                          documentAttributes: nil) else{
            return nil
        }
        return attr
    }
    
    static func getAttributedText(fromHTMLText html: String) -> NSAttributedString?{
        let data = Data(html.utf8)
        guard let attr = try? NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html],
                                          documentAttributes: nil) else{
            return nil
        }
        return attr
    }
}
