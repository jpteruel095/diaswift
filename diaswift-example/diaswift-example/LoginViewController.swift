//
//  LoginViewController.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/30/21.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        guard let username = usernameField.text?.nullableTrimmed,
              let password = passwordField.text?.nullableTrimmed else{
            self.showInvalidInputMessageAlert(message: "Username or Password is not valid.")
            return
        }
        // you can assign on a variable for a "cleaner" code
        let endpoint = LoginEndpoint(username: username, password: password)
        
        /**
         You can also use it without assigning on a variable, e.g.
         LoginEndpoint(username: username, password: password).requestSingle { /// Code goes here /// }
         */
        endpoint.requestSingle { (result) in
            switch result {
            case .success(let json):
                // check if the JSON is null or not
                // and check if token exists
                guard let token = json["token"].string else{
                    self.showErrorMessageAlert(message: "Request did not return any data.")
                    return
                }
                
                // store the token somewhere
                UserDefaults.standard.setValue(token, forKey: "accessToken")
                UserDefaults.standard.synchronize()
            case .failure(let error):
                self.showErrorMessageAlert(error: error)
            }
        }
    }
    
}
