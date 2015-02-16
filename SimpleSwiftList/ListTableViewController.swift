//
//  ViewController.swift
//  SimpleSwiftList
//
//  Created by Gareth Jones on 2/14/15.
//  Copyright (c) 2015 Gareth Jones. All rights reserved.
//


import UIKit
import CoreData

class ListTableViewController: UITableViewController {
    
    // Create an empty array
    var myList:Array<AnyObject> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
        // Reference to our app delegate
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // Reference NSManaged object context
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        let fetchReq = NSFetchRequest(entityName: "List")
        
        // Set title for table view
        self.title = "Shopping List"
        
        // Fetch and reload table data
        myList = context.executeFetchRequest(fetchReq, error: nil)!
        tableView.reloadData()
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // Specify specific segue, prevents nil
        if segue.identifier == "update" {
            let index = tableView.indexPathForSelectedRow()?.row
            var selectedItem: NSManagedObject = myList[index!] as! NSManagedObject
            let seeViewController: ItemSeeViewController = segue.destinationViewController as! ItemSeeViewController
            
            // Pass data through to see item page
            seeViewController.item = selectedItem.valueForKey("item") as? String
            seeViewController.quantity = selectedItem.valueForKey("quantity") as? String
            seeViewController.info = selectedItem.valueForKey("info") as? String
            seeViewController.price = selectedItem.valueForKey("price") as? String
            seeViewController.existingItem = selectedItem
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID: NSString = "Cell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID as! String) as! UITableViewCell
        if let ip = indexPath as NSIndexPath? {
            var data: NSManagedObject = myList[ip.row] as! NSManagedObject
            cell.textLabel?.text = data.valueForKeyPath("item") as? String
            var quantity = data.valueForKeyPath("quantity") as! String
            var info = data.valueForKeyPath("info") as! String
            cell.detailTextLabel?.text = "\(quantity) item/s - \(info)"
        }
        
        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        let appDel:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let tv = self.tableView {
                context.deleteObject(myList[indexPath.row] as! NSManagedObject)
                myList.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            }
            var error: NSError? = nil
            if !context.save(&error) {
                abort()
            }
        }
    }
        
}
