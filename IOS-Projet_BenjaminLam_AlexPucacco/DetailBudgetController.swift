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
    var budget: String!
    @IBOutlet weak var textLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad();
        textLabel.text? = budget;
        print("Hello")
        
    }
    
}
