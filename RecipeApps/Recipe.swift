//
//  Recipe.swift
//  RecipeApps
//
//  Created by Mobile on 11/12/2021.
//  Copyright © 2021 MobileABC. All rights reserved.
//

import Foundation

class Recipe
{
    var id : Int!
    var title : String!
    var detail : String!
    var image : String!
    var type : String!
    
    public init(id: Int, title:String, detail:String, type:String , image:String)
    {
        self.id = id
        self.title = title
        self.detail = detail
        self.image = image
        self.type = type
    }
}
