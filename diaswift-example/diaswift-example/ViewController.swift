//
//  ViewController.swift
//  diaswift-example
//
//  Created by John Patrick Teruel on 3/29/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        ExampleEndpoint().requestMultiple { result in
            switch result{
            case .success(let dict):
                print("Result: \(dict)")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }


}

struct ExampleEndpoint: EndpointProtocol{
    var provider: APIProvider {
        let config = APIConfiguration(domain: "www.example.com", scheme: "http", port: 8080, apiPath: "api/v1", timeout: 120, willMostlyRequireAuth: false)
        return APIProvider(configuration: config, authHeaderHandler: nil, statusCodeHandler: nil)
    }
    let path: String = "user/get"
}
