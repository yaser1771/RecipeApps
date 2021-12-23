//
//  MainViewController.swift
//  RecipeApps
//
//  Created by Mobile on 11/12/2021.
//  Copyright © 2021 MobileABC. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,
    UITableViewDelegate, UITableViewDataSource
{
    @IBOutlet weak var recipeTableView: UITableView!
    
    //Picker section
    let screenWidth = UIScreen.main.bounds.width - 10
    let screenHeight = UIScreen.main.bounds.height / 4
    var selectedRow = 0
    
    var recipeTypes : KeyValuePairs =
    [
        "All Types" : "All Types",
        "Breakfast" : "Breakfast",
        "Lunch" : "Lunch",
        "Dinner" : "Dinner"
    ]
    
    var recipeTypeList = [Recipe]()
    var recipeBackupTypeList = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationNewRecipe(_:)), name: Notification.Name("NewRecipe"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationEditRecipe(_:)), name: Notification.Name("EditedRecipe"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationDeleteRecipe(_:)), name: Notification.Name("DeleteRecipe"), object: nil)
        
        title = "Main"

        initList()

        // Do any additional setup after loading the view.
    }
    
    @objc func didGetNotificationNewRecipe(_ notification: Notification)
    {
        recipeTypeList.append(notification.object as! Recipe)
        
        recipeBackupTypeList = recipeTypeList
        recipeTableView.reloadData()
    }
    
    @objc func didGetNotificationEditRecipe(_ notification: Notification)
    {
        let recipe = notification.object as! Recipe
        
        recipeTypeList.remove(at: recipe.id)
        recipeTypeList.insert(recipe, at: recipe.id) //.remove(at: recipe.id)
        
        recipeBackupTypeList = recipeTypeList
        recipeTableView.reloadData()
    }
    
    @objc func didGetNotificationDeleteRecipe(_ notification: Notification)
    {
        let deletedRecipe = notification.object as! Recipe
        recipeTypeList.remove(at: deletedRecipe.id)
        
        recipeBackupTypeList = recipeTypeList
        recipeTableView.reloadData()
    }
    
    //Picker
    @IBOutlet weak var pickerButton: UIButton!
    
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
            //assign new data to current UI
            self.pickerButton.setTitle(name, for: .normal)
            
            if(name == "All Types")
            {
                self.recipeTypeList = self.recipeBackupTypeList
            }
            else
            {
                self.recipeTypeList = self.recipeBackupTypeList.filter { $0.type == name }
            }
            self.recipeTableView.reloadData()
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
    
    //Table View
    
    func initList()
    {
        let recipe = Recipe(id: 0, title: "Nasi Goreng Kampung",
                            detail: "2 sudu besar Minyak Jagung \n3 ulas Bawang Putih \n1 Bawang \n1 sudu besar Ikan Bilis \n4 tangkai Cili Padi \n1 keping Dada Ayam \n1 sudu besar MAGGI® CukupRasa™ \n1 Telur \n1.65 cawan Nasi (sejuk) \n100 g Kangkung \n2 sudu besar Ikan Bilis \n\nSteps: \n1. Tumbukkan bawang putih, bawang kecil, ikan bilis (yang direndam), cili padi sehingga lumat. \n2. Panaskan minyak, tumiskan bawang putih, bawang kecil, ikan bilis, cili padi sehingga wangi. \n3. Masukkan ayam, tumiskan sehingga bertukar warna. \n4. Masukkan nasi dan sayur kangkung, gaulkan rata. Taburkan MAGGI Cukuprasa, gaul sehingga rata. \n5. Hidangkan bersama ikan bilis",
                            type: "Lunch", image: "recipe")
        
        let recipe1 = Recipe(id: 1, title: "Nasi Lemak",
                             detail: "1.5 sudu besar Minyak Masak \n2.5 cawan Beras \n1 ulas Bawang Putih \n2 cm Halia \n0.5 sudu besar MAGGI® CukupRasa™ \n2 cawan Air \n0.5 cawan Santan \n2 Daun Pandan \n\nSteps: 1. Panaskan minyak dalam kuali dan tumiskan bawang putih bersama halia hingga wangi. \n2. Kemudian, masukkan beras dan masak selama 1 minit. \n3. Selepas itu, masukkan beras tadi dalam periuk nasi bersama MAGGI® CukupRasa™, air, santan dan daun pandan. Kacau dan biarkan ia masak. \n4. Bila dah masak, senduk nasi dan hidangkan panaspanas untuk keluarga. Jangan lupa bahan pelengkap seperti ikan bilis, telur rebus, timun dan kacang.",
                             type: "Breakfast", image: "recipe")
        
        recipeTypeList.append(recipe)
        recipeTypeList.append(recipe1)
        
        recipeBackupTypeList = recipeTypeList
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return recipeTypeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let tableViewCell = tableView.dequeueReusableCell(withIdentifier: "tableViewCellID") as!
            TableViewCell
        
        let thisRecipe = recipeTypeList[indexPath.row]
        
        tableViewCell.recipeName.text = thisRecipe.title
        tableViewCell.recipeImage.image = UIImage(named: thisRecipe.image)
        
        return tableViewCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let selectedRow = recipeTypeList[indexPath.row]
        
        self.performSegue(withIdentifier: "RecipeDetail", sender: selectedRow)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! RecipeDetailViewController
        vc.selectedRecipe = sender as! Recipe?
    }
    
    //Add recipe
    @IBOutlet weak var buttonAddRecipe: UIButton!
    @IBAction func AddButtonClicked(_ sender: Any)
    {
        let vc = storyboard?.instantiateViewController(identifier: "AddRecipe") as! AddRecipeViewController
        navigationController?.pushViewController(vc, animated: true)
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
