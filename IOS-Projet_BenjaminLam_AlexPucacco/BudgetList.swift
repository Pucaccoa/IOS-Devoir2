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
    var listComplete : [ [Item]] = [];
    var catLoaded = false;
    var dataLodaed = false;
    
    @IBOutlet weak var TotalLabel: UILabel!
    
    @IBAction func LogOut(_ sender: Any) {
        let preferences = UserDefaults.standard
        preferences.removeObject(forKey: "username")
        performSegue(withIdentifier: "LogOut", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
        getData()
        getCategories()
        
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return catList.count; //Modifier
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(listComplete)
        if(dataLodaed && catLoaded)
        {
            return listComplete[section].count; //modifi
        }
        else
        {
            return 1;
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(dataLodaed && catLoaded)
        {
            var sum = Float(0);
            for item in listComplete[section]
            {
                sum  = sum + item.amount
            }
            if (!(sum.isEqual(to: Float(0))))
            {
                return "Category Total : " + sum.description + "$" ; //modifier ici
            }
            else
            {
                return nil
            }
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.catList[section].name;
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Budget",
            for : indexPath)
        if(!(dataLodaed && catLoaded))
        {
            return cell
            
        }
        else
        {
            let item = listComplete[indexPath.section][indexPath.row];
            let budget   = item.name;
            cell.textLabel?.text = budget
            let amount = item.amount
            cell.detailTextLabel?.text = amount.description + "$"
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idSegue  = segue.identifier;
        if(idSegue == "Detail")
        {
            let cellule = sender as? UITableViewCell;
            let index = tableView.indexPath(for: cellule!);
            let destination  = segue.destination as? DetailBudgetController
            let budgetTapote = self.listComplete[index!.section][index!.row];
            var catLoaded = false;
            var dataLodaed = false;
            destination?.item = budgetTapote
        }
        
    }
    
    func getData()
    {
        let preferences = UserDefaults.standard
        let username = preferences.string(forKey: "username");
        //print(username);
        
        let session = URLSession.shared // Load configuration into Session
        
        
        let url = URL(string: self.baseUrl + "/item/list/" + username!)!
        let request = URLRequest(url:url)
        
        session.dataTask(with: request) {
            (data, response, error) in
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
                self.dataLodaed = true
                self.createList()
                self.cumulate()
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
                self.catLoaded = true
                
                self.createList()
                self.cumulate()
                self.tableView.reloadData()
            }
            }.resume()
    }
    
    func createList()
    {
        let catList = self.catList
        let itemList = self.itemList;
        let list:[Item]  = [];
        var index = 0;
        if (self.catLoaded && self.dataLodaed)
        {
            print("loaded")
            for cat in catList
            {
                self.listComplete.append(list)
                for item in itemList
                {
                    if(item.categoryId == cat.categoryId)
                    {
                        self.listComplete[index].append(item)
                    }
                }
                index  = index + 1;
            }
        }
    }
    
    func cumulate()
    {
        var sum = Float(0);
        if (self.catLoaded && self.dataLodaed)
        {
            for item in self.itemList
            {
                sum = sum + item.amount
            }
            TotalLabel.text? = "Monthly Total : " + sum.description + "$"
        }
    }
}
