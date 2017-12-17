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
    
    var pickerData = [String]()
    
    var picker_url = "http://budgetmoica.azurewebsites.net/category/list/"
    
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
                        for(key, value) in object
                        {
                            if key == "Name" {
                                self.pickerData.append(value as! String)
                                print(value as! String)
                            }
                        }
                    }
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
}

