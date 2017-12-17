//
//  BudgetList.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by alexpucacco on 2017-12-16.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit


class BudgetList : UITableViewController
{
    var list = ["budget1", "budget2","budget3"];
    var cat = ["Food", "Shopping", "Hobby"];
    var baseUrl = "http://budgetmoica.azurewebsites.net";
    let cellReuseIdentifier = "Budget";
    var itemList:[Item] = [];
    var catList : [Category] = [];
    //var listComplete : [] =
    
    @IBAction func LogOut(_ sender: Any) {
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: "username")
        performSegue(withIdentifier: "LogOut", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
         getData()
        getCategories()
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1; //Modifier
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count; //modifier ici
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cat[section];
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Budget",
            for : indexPath)
        
            let budget   = itemList[indexPath.row].name;
        cell.textLabel?.text = budget
        let amount = itemList[indexPath.row].amount
        cell.detailTextLabel?.text = amount.description
    
        return cell
            
        
        
    }
    
   /*
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "Detail", sender: self);
        
        
     
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idSegue  = segue.identifier;
        if(idSegue == "Detail")
        {
            let cellule = sender as? UITableViewCell;
            let index = tableView.indexPath(for: cellule!)?.row;
            let destination  = segue.destination as? DetailBudgetController
            let budgetTapote = self.itemList[index!];
            print(self.itemList[index!].name)
            destination?.budget = budgetTapote
            
        }
        
    }
    func getData()
    {
        
        
        
        let preferences = UserDefaults.standard
        let username = preferences.string(forKey: "username");
        print(username);
        
        let session = URLSession.shared // Load configuration into Session
        
        
        let url = URL(string: self.baseUrl + "/item/list/" + username!)!
        let request = URLRequest(url:url)
        
        session.dataTask(with: request) {
            (data, response, error) in
            print("Hello3")
            
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
                            if let item = Item(json:object as! [String : Any])
                            {
                                self.itemList.append(item)
                                
                                
                            }
                            
                            
                        }
                    }
                    
                    
                }catch
                {
                    print(error)
                    
                }
            }
            
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
            
            
        }.resume()
        
        
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
            for cat in self.catList
            {
                print (cat.name)
            }
            OperationQueue.main.addOperation {
                self.tableView.reloadData()
            }
            
            
            }.resume()

        
        
    }
    
    
}
