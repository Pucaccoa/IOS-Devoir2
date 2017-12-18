//
//  DetailBudgetController.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by alexpucacco on 2017-12-16.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit

class DetailBudgetController : UIViewController
{
    var item: Item!
    var baseUrl = "http://budgetmoica.azurewebsites.net";
    var catList : [Category] = [];
    @IBOutlet weak var Name: UILabel!
    @IBOutlet weak var Description: UILabel!
    @IBOutlet weak var Amount: UILabel!
    @IBOutlet weak var CategoryName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        Name.text? = "Name : " + item.name;
        Amount.text? = "Amount : " + item.amount.description + "$";
        Description.text = "Description : " + item.description;
        CategoryName.text? = "Category : " + item.categoryId.description;
        getCategories()
    }
    
    func getCategories()
    {
        let session = URLSession.shared // Load configuration into Session
        let url = URL(string: self.baseUrl + "/category/list" )!
        let request = URLRequest(url:url)
        session.dataTask(with: request) {
            (data, response, error) in
            if let rep = response
            {
                print(rep);
            }
            if let donnees = data
            {
                do
                {
                    let json  = try JSONSerialization.jsonObject(with: donnees, options: [])
                    
                    if let array = json as? [Any]
                    {
                        for object in array
                        {
                            if let cat = Category(json:object as! [String : Any])
                            {
                                self.catList.append(cat)
                            }
                        }
                    }
                }catch
                {
                    print(error)
                }
            }
            OperationQueue.main.addOperation {
                self.updateCategory()
            }
            }.resume()
        
        
        
    }
    
    @IBAction func BackButton(_ sender: Any) {
        performSegue(withIdentifier: "GoBackToList", sender: self)
        
    }
    @IBAction func Delete(_ sender: Any) {
        let url = URL(string: self.baseUrl + "/item/delete/" + self.item.itemId.description)
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if (response as! HTTPURLResponse).statusCode == 200 {
                print("Item Delete success!")
                OperationQueue.main.addOperation {
                    self.performSegue(withIdentifier: "goBackDelete", sender: self)
                }
            }
            else
            {
                print("Item Delete failed : ")
                print(response)
            }
        }.resume()
    }
    func updateCategory()
    {
        var catName = "";
        for cat in self.catList
        {
            if cat.categoryId == self.item.categoryId
            {
                catName = cat.name
            }
        }
        self.CategoryName.text? = catName
    }
    
    @IBAction func Edit(_ sender: Any) {
        performSegue(withIdentifier: "EditItem", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idSegue  = segue.identifier;
        if(idSegue == "EditItem")
        {
            let destination  = segue.destination as? EditItemController
            destination?.item = item
            destination?.categoryName = self.CategoryName.text!
        }
    }
    
    
}
