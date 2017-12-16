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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1; //Modifier
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count; //modifier ici
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let cell = tableView.dequeueReusableCell(withIdentifier: "Budget",
            for : indexPath)
            let budget   = list[indexPath.row];
        cell.textLabel?.text = budget
        cell.detailTextLabel?.text = "Test Budget"
    
        return cell
            
        
        
    }
    
}
