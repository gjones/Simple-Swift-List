//
//  ItemViewController.swift
//  SimpleSwiftList
//
//  Created by Gareth Jones on 2/14/15.
//  Copyright (c) 2015 Gareth Jones. All rights reserved.
//

import UIKit
import CoreData

class ItemViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textFieldItem: UITextField!
    @IBOutlet var textFieldQuantity: UITextField!
    @IBOutlet var textFieldInfo: UITextField!
    
    var item: String?
    var quantity: String?
    var info: String?
    
    var existingItem: NSManagedObject!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (existingItem != nil) {
            textFieldItem.text = item
            textFieldQuantity.text = quantity
            textFieldInfo.text = info
        }
        //This makes it so that textFieldShouldReturn works and the keyboard hides when the user clicks return
        textFieldItem.delegate = self
        textFieldQuantity.delegate = self
        textFieldInfo.delegate = self
        
        if item != nil {
            title = item
        }
        
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        
        // Reference to our app delegate
        let appDel: AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Reference NSManaged object context
        let context: NSManagedObjectContext = appDel.managedObjectContext! //I unwrapped but tutorial didn't say that
        let entity = NSEntityDescription.entityForName("List", inManagedObjectContext: context)
        
        // Check if item exists
        if (existingItem != nil) {
            existingItem.setValue(textFieldItem.text as String, forKey: "item")
            existingItem.setValue(textFieldQuantity.text as String, forKey: "quantity")
            existingItem.setValue(textFieldInfo.text as String, forKey: "info")
        } else {
            // Create instance of our data model and initialize
            var newItem = Model(entity: entity!, insertIntoManagedObjectContext: context)
            // Map our properties
            newItem.item = textFieldItem.text
            newItem.quantity = textFieldQuantity.text
            newItem.info = textFieldInfo.text
        }
        
        // Save our context
        context.save(nil)
        
        // Navigate back to previous controller
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
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
