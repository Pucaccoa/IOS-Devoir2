//
//  AuthenticationController.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by Benjamin on 2017-12-16.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit

class AuthenticationController : UIViewController {
    
    let login_url = "http://budgetmoica.azurewebsites.net/user/login/"
    var validPass = true
    var validUsername = true
    
    @IBOutlet weak var txt_username: UITextField!
    
    @IBOutlet weak var txt_password: UITextField!
    
    @IBAction func Login(_ sender: Any) {
        //validate the fields, do nothing if invalid
        if txt_username.text == "" {
            validUsername = false
        }
        if txt_password.text == "" {
            validPass = false
        }
        
        if validUsername == true || validPass == true {
            attemptLogin(username: txt_username.text!, password: txt_password.text!)
        }
    }
    
    func attemptLogin(username: String,password: String)
    {
        let url = URL(string: login_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["Username" : username, "Password": password]
        do{
            let dataReq = try JSONSerialization.data(withJSONObject: parameters, options: [])
            print(dataReq)
            request.httpBody = dataReq
        } catch{
            print("Error")
        }
        
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if (response as! HTTPURLResponse).statusCode == 200 {
                print("Login success!")
                OperationQueue.main.addOperation {
                        self.performSegue(withIdentifier: "ShowMain", sender: self)
                    }
                }
        }.resume()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
