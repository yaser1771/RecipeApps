//
//  RecipeDetailViewController.swift
//  RecipeApps
//
//  Created by Mobile on 11/12/2021.
//  Copyright © 2021 MobileABC. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController
{

    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UILabel!
    @IBOutlet weak var recipeType: UILabel!
    @IBOutlet weak var recipeDetails: UITextView!
    
    var selectedRecipe: Recipe!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        title = "Recipe Details"
        
        recipeImage.image = UIImage(named: selectedRecipe!.image)
        recipeTitle.text = selectedRecipe!.title
        recipeType.text = "Types : " + selectedRecipe!.type
        recipeDetails.text = selectedRecipe!.detail
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationEditRecipe(_:)), name: Notification.Name("EditedRecipe"), object: nil)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func didGetNotificationEditRecipe(_ notification: Notification)
    {
        selectedRecipe = notification.object as? Recipe
        
        recipeImage.image = UIImage(named: selectedRecipe!.image)
        recipeTitle.text = selectedRecipe!.title
        recipeType.text = "Types : " + selectedRecipe!.type
        recipeDetails.text = selectedRecipe!.detail
    }
    
    @IBAction func editButtonClicked(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(identifier: "AddRecipe") as! AddRecipeViewController
        vc.selectedRecipe = selectedRecipe
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func deleteButtonClicked(_ sender: Any)
    {
        NotificationCenter.default.post(name: Notification.Name("DeleteRecipe"), object: selectedRecipe)
        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
