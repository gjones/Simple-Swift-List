//
//  ItemSeeViewController.swift
//  SimpleSwiftList
//
//  Created by Gareth Jones on 2/14/15.
//  Copyright (c) 2015 Gareth Jones. All rights reserved.
//

import UIKit
import CoreData

class ItemSeeViewController: UIViewController {
    
    @IBOutlet weak var labelItem: UILabel!
    @IBOutlet weak var labelQuantity: UILabel!
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelEdit: UILabel!
    @IBOutlet weak var labelTotalPrice: UILabel!
    
    @IBOutlet weak var textFieldItem: UITextField!
    @IBOutlet weak var textFieldQuantity: UITextField!
    @IBOutlet weak var textFieldInfo: UITextField!
    @IBOutlet weak var textFieldPrice: UITextField!
    
    var item: String?
    var quantity: String?
    var info: String?
    var price: String?
    
    var existingItem: NSManagedObject!
    
    @IBAction func updateTapped(sender: AnyObject) {
        //Reference to our app delegate
        
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //Reference NSManaged object context
        
        let context: NSManagedObjectContext = appDel.managedObjectContext! //I unwrapped but tutorial didn't say that
        let entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)
        
        //Check if item exists
        
        if (existingItem != nil) {
            existingItem.setValue(textFieldItem.text as String, forKey: "item")
            existingItem.setValue(textFieldQuantity.text as String, forKey: "quantity")
            existingItem.setValue(textFieldInfo.text as String, forKey: "info")
            existingItem.setValue(textFieldPrice.text as String, forKey: "price")
        } else {
            //Create instance of our data model and initialize
            var newItem = Model(entity: entity!, insertIntoManagedObjectContext: context)
            
            //Map our properties
            newItem.item = textFieldItem.text
            newItem.quantity = textFieldQuantity.text
            newItem.info = textFieldInfo.text
            newItem.price = textFieldPrice.text
        }
        
        //Save our context
        context.save(nil)
        
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelItem.text = item
        labelQuantity.text = quantity
        labelInfo.text = info
        
        if price != nil {
            
            var cost = price?.toInt()
            var amount = quantity?.toInt()
            var totes = cost! * amount!
            labelTotalPrice.text = "£ \(totes)"
        } else {
            labelTotalPrice.text = "None"
        }
        
        if (existingItem != nil) {
            textFieldItem.text = item
            textFieldQuantity.text = quantity
            textFieldInfo.text = info
            textFieldPrice.text = price
        }
        
        if item != nil {
            self.title = item
            labelEdit.text = "Edit \(item!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
