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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return list.count; //Modifier
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2; //modifier ici
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let idSegue  = segue.identifier;
        if(idSegue == "Detail")
        {
            let cellule = sender as? UITableViewCell;
            let index = tableView.indexPath(for: cellule!)?.row;
            let destination  = segue.destination as? DetailBudgetController
            let budgetTapote = list[index!];
            destination?.budget = budgetTapote
            print("Hello2")
        }
        
    }
    
    
}
