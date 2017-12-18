//
//  RegistrationController.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by Benjamin on 2017-12-16.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit
class RegistrationController : UIViewController {
    
    var validUsername = true
    var validPass = true
    var validCPass = true
    var register_url = "http://budgetmoica.azurewebsites.net/user/register/"
    
    @IBOutlet weak var btnConfirm: UIButton!
    
    @IBOutlet weak var txt_username: UITextField!
    
    @IBOutlet weak var txt_password: UITextField!
    
    @IBOutlet weak var txt_cpassword: UITextField!
    
    @IBOutlet weak var username_error: UILabel!
    
    @IBOutlet weak var password_error: UILabel!
    
    @IBOutlet weak var cpassword_error: UILabel!
    
    @IBOutlet weak var register_error: UILabel!
    
    @IBAction func SignUp(_ sender: Any) {
        
        username_error.text = ""
        password_error.text = ""
        cpassword_error.text = ""
        
        let username = txt_username.text
        let password = txt_password.text
        let cpassword = txt_cpassword.text
        
        if username == ""
        {
            username_error.text = "Username required"
            validUsername = false
        }
        if password == ""
        {
            password_error.text = "Password Required"
            validPass = false
        }
        if cpassword == ""
        {
            cpassword_error.text?.append("Confirm password required. ")
            validCPass = false
        }
        
        if cpassword != password
        {
            cpassword_error.text?.append("Passwords do not match.")
            validCPass = false
        }
        
        if validUsername == true && validPass == true && validCPass == true {
            attemptSignUp(username: username!, password: password!)
        }
        
    }
    
    func attemptSignUp(username: String, password: String)
    {
        let url = URL(string: register_url)
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
                print("Sign up success!")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "ShowLogin", sender: self)
                }
            } else {
                self.register_error.text = "Error"
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
