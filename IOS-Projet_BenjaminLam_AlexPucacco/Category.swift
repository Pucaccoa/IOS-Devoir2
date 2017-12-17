//
//  Category.swift
//  IOS-Projet_BenjaminLam_AlexPucacco
//
//  Created by alexpucacco on 2017-12-17.
//  Copyright © 2017 alexpucacco. All rights reserved.
//

import Foundation

struct Category {
    let description :String
    let name : String
    let categoryId: Int
    
}

extension Category
{
    init?(json:[String:Any])
    {
        guard
            let description = json["Description"] as? String,
            let name = json["Name"] as? String,
            let categoryId = json["CategoryId"] as? Int
            else{
                return nil
        }
        self.name = name;
        self.description = description;
        self.categoryId = categoryId;
        
        
    }
}
