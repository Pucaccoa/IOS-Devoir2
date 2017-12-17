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
    
    let cellReuseIdentifier = "Budget";
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    
}
