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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData();
        //self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1; //Modifier
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count; //modifier ici
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.cat[section]
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Budget",
            for : indexPath)
        
            let budget   = list[indexPath.row];
        cell.textLabel?.text = budget
        cell.detailTextLabel?.text = "Test Budget"
    
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
            let budgetTapote = list[index!];
            print(list[index!])
            destination?.budget = budgetTapote
            
        }
        
    }
    func getData()
    {
        let config = URLSessionConfiguration.default // Session Configuration
        let session = URLSession(configuration: config) // Load configuration into Session
        let preferences = UserDefaults.standard
        let username = preferences.string(forKey: "username");
        
        let url = URL(string: self.baseUrl + "/item/list/" + username!)!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            print("Hello3")
            if error != nil {
                
                print(error!.localizedDescription)
                
            } else {
                
                do {
                    
                    if let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any]
                    {
                        
                        //Implement your logic
                        print(json)
                        
                    }
                    
                } catch {
                    
                    print("error in JSONSerialization")
                    
                }
                
                
            }
            
        })
        task.resume()
    }
    
    
}
