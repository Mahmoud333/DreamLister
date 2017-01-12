//
//  ViewController.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 11/14/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit
import CoreData

class MacinVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    
    // FRC Fetched Result Controller do: works directly with core data and with ur tableview to make it easier to work with fetched result
    // FRC efficiently collects all information about the result without the need to bring all the results to the memory at the same time - keep the memory requirments low
    var fetchedResultsController: NSFetchedResultsController<Item>! // what kind of entity u will fetch item data class
    //var fetchedResultsController: NSFetchedResultsController<Item>!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    
        generateTestData()
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    // MARK : UITableView Delegate and DataSource
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //traditionly we make the cell & configure it here but it will be different this time
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        
        configureCell(cell, indexPath: indexPath) //made cell send it to the other method
        
        return cell
        //1-Prepare it here
        //2-Call configure cell here
        //3-Call another configure cell in ItemCell Class
    }
    //Go From here to there
    func configureCell(_ cell: ItemCell, indexPath: IndexPath) {
        //Update Cell, u dont want ur view contoller to be manuplating ur Views, MVC concept
        
        let item = fetchedResultsController.object(at: indexPath) // create variable for item
        cell.configureCell(item) // then call configure cell (in ItemCell) and pass item variable
        
    }
    
    
    //
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        //prepare to send the object Item from here to DetailsVC
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 { //make sure there are object in the controller
        
            let item = objs[indexPath.row] //make item equal to specific item in the list (the one we selected)
            
            performSegue(withIdentifier: "ItemDetailsVC", sender: item) //send the item (squeeze it as a sender)
            
        }
    }
    //
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ItemDetailsVC" {
            if let destination = segue.destination as? ItemDetailsVC {
                if let item = sender as? Item {
                    
                    destination.itemToEdit = item
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections { //grabing the sections out of the controller
            
            let sectionInfo = sections[section] //and grab the section out of it
            return sectionInfo.numberOfObjects // if there is section in it, we will get info out of it, and then count them
        }
        return 0
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        
        if let sections = fetchedResultsController.sections {
            return sections.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150 // so height stays 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
            
        } else if segment.selectedSegmentIndex == 1 {
            
            fetchRequest.sortDescriptors = [priceSort]
            
        } else if segment.selectedSegmentIndex == 2 {
            
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        controller.delegate = self
        
        self.fetchedResultsController = controller
        
        do {
            
            try controller.performFetch()
            
        } catch let error as NSError {

            print("\(error)")
            
        }
        
    }
    
    // once we have data on our database we need a way to go and fetch it & then display it
    /*
    func attemptFetch() {
        setFetchedResults()
        
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let error = error as NSError
            print("\(error), \(error.userInfo)")
        }
    }
    
    func setFetchedResults() {
        let section: String? = segment.selectedSegmentIndex == 1 ? "store.name" : nil
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "created", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: section, cacheName: nil)
        
        controller.delegate = self
        
        fetchedResultsController = controller
        
        
    }
    */
    
/*    func attemptFetch() {
        
        //let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        //let fetchRequest: NSFetchRequest = Item.fetchRequest()
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest
        
        // tell the fetched controller how to sort
        let dateSort = NSSortDescriptor(key: "created", ascending:  false) //u will sort this based on created
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        //let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true, selector: #selector(NSString.localizedCaseInsensitiveCompare(_:)))
        
        if segment.selectedSegmentIndex == 0 {
            
            fetchRequest.sortDescriptors = [dateSort]
        } else if segment.selectedSegmentIndex == 1 {
           
            fetchRequest.sortDescriptors = [priceSort]
        } else if segment.selectedSegmentIndex == 2 {
           
            fetchRequest.sortDescriptors = [titleSort]
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        //NSManagedObjectContext is like a scrath pad, sectionNameKeyPath is nil coz we want return all the result,
    
        controller.delegate = self
        // so (controllerWillChangeContent & controllerDidChangeContent ) methods work
        fetchedResultsController = controller
        
        //do the fetch now
        do {
            try self.fetchedResultsController.performFetch() //Like self here :D
        
        } catch {
            let error = error as NSError
            print(error)
        }
    } */
    // Recap: we created our attemptFetch function, and we created our controller, and then passed in which fetchRequest we are working with we will be fetching items, told it how we want it to be sorted, then perform the actual fetch
    @IBAction func segmentChange(_ sender: UISegmentedControl) { //of type (value changed) gets called everytime someone change the value
        
        //everytime they change the segment
        attemptFetch()
        //so we can sort it according to the segment he choosed
        tableView.reloadData()
    }
    
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //whenever the tableview is about to update this will start to listen for changes and will handle that for you, in Pokedex how when u change photo in pokemon list every single time u had to say tableView.reloaddata
        tableView.beginUpdates() //using coredata and FRC to help us insert and delete and modify
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // it might be a good idea to put them all in different extension or parent class so u don't have to write all this out for every single controller
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        //this will be listening for when we are gona make change whatsever its insertion or deletion or modification
        
        switch (type) {
        case .insert: //this is when u create new item, when u saw ur ferrari and wanted to save it
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade) //style of animation
            }
            break
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            break
        case .update: // if u clicked on existing item and wanted to update
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                
                // Work Later: Update The Cell Data
                configureCell(cell, indexPath: indexPath) //the local one
                // what is does: when we update a cell when it comes back it will go through that configuer cell function once again and update the results for us that will be nice ;)
            }
            break
        case .move: //if you have touch moving impemented and they are dragging it so what we are doing is deleting it at current place and gonna insert it at
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
            if let indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break
        
        }
    }


    func generateTestData() { //put items in manage Context and save them
        
        //let item = Item(context: context) //created an item of the entity Item inside NSManagedObjectContext
        //let itemDescription = NSEntityDescription.insertNewObject(forEntityName: "Item", into: context)
        let item = Item(context: context)
        item.title = "MacBook Pro"
        item.price = 1800
        item.details = "I can't wait until the september event, I hope they release new MBPs"

        let item2 = Item(context: context)
        item2.title = "Bose Headphones"
        item2.price = 300
        item2.details = "But man, its so nice to be able to block out everyone with the noise canceling tech"
        
        let item3 = Item(context: context)
        item3.title = "Lamborghini Murcielago LP670-4 SV"
        item3.price = 400000
        item3.details = "oh man this is a beautiful car. And one day, I will own it"
        
        ad.saveContext()
    }
    
}

