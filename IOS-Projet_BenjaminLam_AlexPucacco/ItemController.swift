//
//  ItemController.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by Benjamin on 2017-12-17.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit

class ItemController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    @IBOutlet weak var txt_itemname: UITextField!
    
    @IBOutlet weak var txt_itemamount: UITextField!
    
    @IBOutlet weak var txt_description: UITextView!
    
    @IBOutlet weak var txt_categorypicker: UIPickerView!
    
    @IBOutlet weak var errors: UILabel!
    
    var categoryvalue = ""
    var validItem = true
    
    @IBAction func CreateItem(_ sender: Any) {
        
        errors.text = ""
        validItem = true
        let name = txt_itemname.text
        let amount = txt_itemamount.text
        let description = txt_description.text

        if categoryvalue == ""
        {
            errors.text?.append("Category required. ")
            validItem = false
        }
        
        if name == "" {
            errors.text?.append("Name required. ")
            validItem = false
        }
        
        if amount == "" {
            errors.text?.append("Amount required. ")
            validItem = false
        }
        
        if description == "" {
            errors.text?.append("Description required. ")
            validItem = false
        }
        
        if validItem == true {
            print(categoryvalue)
            let preferences = UserDefaults.standard
            let username = preferences.string(forKey: "username")
            attemptCreate(username: username!, categoryName: categoryvalue, itemName: name!, itemAmount: amount!, itemDesc: description!)
        }
        
    }
    var pickerData = [String]()
    
    var picker_url = "http://budgetmoica.azurewebsites.net/category/list/"
    var createitem_url = "http://budgetmoica.azurewebsites.net/item/create/"
    
    func attemptCreate(username: String, categoryName: String, itemName: String, itemAmount: String, itemDesc: String)
    {
        let url = URL(string: createitem_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["Username" : username, "CategoryName": categoryName, "Name" : itemName, "Amount" : itemAmount, "Description" : itemDesc]
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
                print("Item creation success!")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "AfterCreate", sender: self)
                }
            }
            }.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        txt_categorypicker.dataSource = self
        txt_categorypicker.delegate = self
        let url = URL(string: picker_url)
        
        let task = URLSession.shared.dataTask(with: url!){ (data, response, error) in
            if (response as! HTTPURLResponse).statusCode == 200 {
                let json = try? JSONSerialization.jsonObject(with: data!, options: [])
                if let array = json as? [Any]
                {
                    for object in array
                    {
                        if let cat = Category(json:object as! [String : Any])
                        {
                            self.pickerData.append(cat.name)
                        }
                    }
                    self.txt_categorypicker.reloadAllComponents()
                }
            }
        }
        task.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        categoryvalue = pickerData[row]
    }
}

