//
//  Item.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by alexpucacco on 2017-12-17.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation
import UIKit

struct Item {
    let amount : Float
    let description :String
    let itemId : Int
    let name : String
    let categoryId: Int
    
}

extension Item
{
    init?(json:[String:Any])
    {
        guard let amount = json["Amount"] as? Float,
        let description = json["Description"] as? String,
        let itemId = json["ItemId"] as? Int,
        let name = json["Name"] as? String,
        let categoryId = json["CategoryId"] as? Int
            
            else{
                return nil
        }
        self.name = name;
        self.amount = amount;
        self.description = description;
        self.itemId = itemId;
        self.categoryId = categoryId;
        
        
    }
}
