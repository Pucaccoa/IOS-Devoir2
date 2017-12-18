//
//  EditItemController.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by alexpucacco on 2017-12-17.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit

class EditItemController: ViewController,UIPickerViewDelegate, UIPickerViewDataSource{
    
    var item : Item!
    var categoryName : String = ""
    var picker_url = "http://budgetmoica.azurewebsites.net/category/list/"
    var edititem_url = "http://budgetmoica.azurewebsites.net/item/edit/"
    
    var pickerData = [Category]()
    var categoryvalue = ""
    var didSelect = false;
    var validItem = true
    
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var AmountField: UITextField!
    @IBOutlet weak var TextViewDescription: UITextView!
    @IBOutlet weak var picker: UIPickerView!
    @IBOutlet weak var errors: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        AmountField.text? = item.amount.description
        nameField.text? = item.name
        TextViewDescription.text? = item.description
        var index  = 0;
        var row = 0;
        categoryvalue = categoryName
        for cat in pickerData
        {
            if(cat.name == categoryName)
            {
                row = index
                print(row)
            }
            index = index + 1
        }
        picker.selectRow(row, inComponent: 0, animated: true)
        picker.dataSource = self
        picker.delegate = self
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
                            self.pickerData.append(cat)
                        }
                    }
                    self.picker.reloadAllComponents()
                }
            }
        }
        task.resume()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.didSelect = true
        categoryvalue = pickerData[row].name
    }
    
    func attemptEdit(itemId : Int,categoryName:String,
                     itemName:String,itemAmount:String,itemDesc:String)
    {
        let url = URL(string: edititem_url)
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let parameters = ["ItemId" : itemId, "CategoryName": categoryName, "Name" : itemName, "Amount" : itemAmount, "Description" : itemDesc] as [String : Any]
        do{
            let dataReq = try JSONSerialization.data(withJSONObject: parameters, options: [])
            request.httpBody = dataReq
        } catch{
            print("Error")
        }
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if (response as! HTTPURLResponse).statusCode == 200 {
                print("Item edit success!")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "goBackHome", sender: self)
                }
            }
            else
            {
                print("Item Edit failed : ")
                print(response)
            }
        }.resume()
    }
    
    @IBAction func SaveChanges(_ sender: Any) {
        errors.text = ""
        validItem = true
        let name = nameField.text
        let amount = AmountField.text
        let description = TextViewDescription.text
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
            attemptEdit(itemId:item.itemId, categoryName: categoryvalue, itemName: name!, itemAmount: amount!, itemDesc: description!)
        }
    }
    @IBAction func BackToList(_ sender: Any) {
        self.performSegue(withIdentifier: "GoBackToList", sender: self)
    }
}
