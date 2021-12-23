//
//  ListViewController.swift
//  RecipeApps
//
//  Created by Mobile on 11/12/2021.
//  Copyright © 2021 MobileABC. All rights reserved.
//

import UIKit

class AddRecipeViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource
{
    @IBOutlet weak var recipeImage: UIImageView!
    @IBOutlet weak var recipeTitle: UITextField!
    @IBOutlet weak var recipeDetails: UITextView!
    @IBOutlet weak var pickerButton: UIButton!
    @IBOutlet weak var recipeType: UITextField!
    
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRow = 0
    
    var recipeTypes : KeyValuePairs =
    [
        "Breakfast" : "Breakfast",
        "Lunch" : "Lunch",
        "Dinner" : "Dinner"
    ]
    
    var selectedRecipe: Recipe!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        title = "Add Recipe"
        
        if(selectedRecipe != nil)
        {
            recipeImage.image = UIImage(named: selectedRecipe!.image)
            recipeTitle.text = selectedRecipe!.title
            recipeDetails.text = selectedRecipe!.detail
            recipeType.text = selectedRecipe!.type
            
            title = "Edit Recipe"
        }
    }
    
    @IBAction func saveButtonClicked()
    {
        let count = Int.random(in: 0..<99)
        let recipeDetail = Recipe(id: count, title: recipeTitle.text!, detail: recipeDetails.text!, type: recipeType.text!, image: "recipe")
        
        if(recipeTitle.text == "" && recipeDetails.text == "" && recipeType.text == "")
        {
            
        }
        else
        {
            if(title == "Edit Recipe")
            {
                recipeDetail.id = selectedRecipe.id
                NotificationCenter.default.post(name: Notification.Name("EditedRecipe"), object: recipeDetail)
            }
            else
            {
                NotificationCenter.default.post(name: Notification.Name("NewRecipe"), object: recipeDetail)
            }
        }
        
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    //Picker section
    @IBAction func pickerPopup(_ sender: Any)
    {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: screenWidth, height: screenHeight)
        
        let picker = UIPickerView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
        picker.dataSource = self
        picker.delegate = self
        
        picker.selectRow(selectedRow, inComponent: 0, animated: false)
        
        vc.view.addSubview(picker)
        picker.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor).isActive = true
        picker.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor).isActive = true
        
        let alert = UIAlertController(title: "Select Recipe Type", message: "", preferredStyle: .actionSheet)
        
        alert.popoverPresentationController?.sourceView = picker
        alert.popoverPresentationController?.sourceRect = picker.bounds
        
        alert.setValue(vc, forKey: "contentViewController")
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { (UIAlertAction) in
            //get selected data
            self.selectedRow = picker.selectedRow(inComponent: 0)
            let selected = Array(self.recipeTypes)[self.selectedRow]
            let name = selected.key
            self.recipeType.text = name
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView
    {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 20))
        label.text = Array(recipeTypes)[row].key
        label.sizeToFit()
        return label
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        recipeTypes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat
    {
        return 40
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
