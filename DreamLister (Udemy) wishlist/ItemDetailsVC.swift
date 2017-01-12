//
//  ItemDetailVC.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 11/17/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    
    @IBOutlet weak var thumgImg: UIImageView!
    var stores: Array = [Store]()   //Array to hold our stores
    var itemToEdit: Item? //optional bec. we are not always editing in this view
    var imagePicker: UIImagePickerController!
    
    var itemTypes: Array = [ItemType]()
    var wheelContents = [Array<Any>]()
    
    // ItemType Doesn't work very well
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Remove the Title of the previous Controller
        if let topItem = self.navigationController?.navigationBar.topItem {
            
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }

        storePicker.delegate = self
        storePicker.dataSource = self
        
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        //go ahead and Create some stores & set the names and gonna save them in Core Data & gonna fetch it back and asign the fetch result to the empty Stores array and then they will be used in DataSource and Delegate methods (exp: title for row)
        
        //generateTestData()
        getStores()
        //generateTypeTestData()
        getItemTypes()
        
        wheelContents = [stores,itemTypes]
        
        if itemToEdit != nil { //if we have passed an existed object into this view
            
            loadItemData() //then we will load that loadItemData thats coming from main View
        } else {
            
        }
        
    }

    // How many rows there are
    // How many sections there are
    // What to do when one of them is selected
    // The One that sets the title for rows
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
//        let store = stores[row] //Select store out of the array of stores, at that row
//        return store.name //the name of that store
        
        var title: String!
        
        if component == 0 {
            let store = stores[row]
            title = store.name
        }else if component == 1 {
            let itemType = itemTypes[row]
            title = itemType.type
        }
        
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //return stores.count
        return (wheelContents[component] as AnyObject).count //wheelContents[1].count & wheelContents[2].count
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // How many coloums there are
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        // Update When selected
    }
    //
    
    func getStores() {
        
        //let fetchRequest: fetchRequest = fetchRequest(entityName: "Store")
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        
        do {
            self.stores = try context.fetch(fetchRequest)
            self.storePicker.reloadAllComponents() //like the tableView.reloadData
        
        } catch let error as NSError {
            print(error)
        }
        
    }
    func getItemTypes() {
        
        //let fetchRequest: fetchRequest = fetchRequest(entityName: "ItemType")
        let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
        
        do {
            self.itemTypes = try context.fetch(fetchRequest) as! [ItemType]
            self.storePicker.reloadAllComponents()
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        // what happen when they press save item:
        // we gonna insert an object inside managed object context we gonna assign the title, price and details of text field to attributes of that item and then save that item to database (CoreData)
        
        var item: Item! //decleare it as an item
        
        if itemToEdit == nil {
            //create new item
            item = Item(entity: NSEntityDescription.entity(forEntityName: "Item", in: context)!, insertInto: context)     // insert entity/Item in NSManagedObjectContext

        } else {
            
            item = itemToEdit //Core Data will take care of the rest behind the scene it will know it just need to update the existing one
        }
        
        let picture = Image(entity: NSEntityDescription.entity(forEntityName: "Image", in: context)!, insertInto: context) // create/insert image entity in ManagedObjectContext (didnt create it yet) called pictuer
        picture.image = thumgImg.image //assigning image attributes of Picture to the image we choose from ImagePicker
        
        //now associate this image to our item
        item.toImage = picture //bec. w assigning entity to entity
        
        //assigning inside of each textFields to the attributes for the item
        //we are not going to do too much error handling like puting letters in price title
        
        if let title = titleField.text {
            item.title = title
        }
        
        if let details = detailsField.text {
            item.details = details
        }
        
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue as NSNumber?
            //price attrivute is Double, so we are gonna take the string and turn it to NSString bec. to use property in NSString and make quik convertion
        }
        
        //Assign the store we have selected
        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]//we are assigning store via these relationship to this item, selecting the store inside the stores array
        
        //Assign ItemType
        item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
        print("\(item.toItemType?.type)")
        
        //that corespond to those storePicker, & inComponent this isn't row its Column & we only have 1 column
        
        //it grabs relationship that we defined inside Model (dont name it like this again)
        
        //in title,details and prices they was attributes but store is already an Entity of itself, it already been created, when we created array of entity store, we created bunch of store entities in (generateTestData) & stored them in that array & UIPickerView is just selecting those indexs
        
        ad.saveContext() //and then save it
        
        //now take us back to main VC, dismiss VC
        _ = navigationController?.popViewController(animated: true)
    }
    
    //load in our textField the information from the existing cell (if its Edit)
    func loadItemData() {
        
        if let item = itemToEdit {
            
            titleField.text = item.title
            if item.price != nil {
            priceField.text = "\(item.price!.doubleValue)" //so it don't appear as optional
            }
            detailsField.text = item.details
            thumgImg.image = item.toImage?.image as? UIImage
            
            //set picker to correct store (tricky)
            //all we have is the store name in string(Main VC) and here we have it stored in array
            //so we will loop through & compare the name 1 to 1 until we find the correct 1 and asign the picker view to that index
            
            if let store = item.toStore { //if we have store (item might not have 1)
                // was (if let store = item.toStore as? Store)
                var index = 0 // to start
                repeat {
                    
                    let s = stores[index] // go 1 by 1
                    if s.name == store.name {
                        
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        // the row it will select is the index bec. its the num of the same store string
                        // bec. we checking if name compare and if they do match then we wil set row to that index
                        
                        break //once we have the right one we are done
                    }
                    index += 1 //make sure we increase index
                    
                } while (index < stores.count) //as many store we have
            }
        
            if let type = item.toItemType {
                print("toItemType is not nil")
                
                var index = 0
                repeat {
                    
                    let t = itemTypes[index]
                    if t.type == type.type {
                        
                        storePicker.selectRow(index, inComponent: 1, animated: false)
                        print("index: \(index)")
                        break
                        
                    }
                    index += 1
                } while (index < itemTypes.count)
            
            }
        
            for i in 0 ... itemTypes.count - 1 {
                
                let type = item.toItemType
                let t = itemTypes[i]
                if t.type == type?.type {
                    storePicker.selectRow(i, inComponent: 1, animated: false)
                    print("I: \(i)")
                    break
                    
                }
            }

            
            
            
            
        }
        
        
    }
    
    @IBAction func deletePressed(_ sender: UIBarButtonItem) {
        // make quick check bec. we only want to delete if we have passed one of our existing objects over
        if itemToEdit != nil { //if we have something and want to delete it
            context.delete(itemToEdit!)
            ad.saveContext() //save that and thats it ;D
        }
        
        //once we delete it pop back to the controller
        _ = navigationController?.popViewController(animated: true)
    }
    
    //have it when we click on imageButton have it present imagesViewController so we can use pur camera roll to select images 
    //Button Pressed
    @IBAction func addImage(_ sender: UIButton) {
        
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            thumgImg.image = img
        } //now we have our imagePickerController
        imagePicker.dismiss(animated: true, completion: nil) //dismiss the view Controller after choosing the image
    }
    
    func generateTestData() {
        let storeDescription = NSEntityDescription.entity(forEntityName: "Store", in: context)
        let store = Store(entity: storeDescription!, insertInto: context)
        store.name = "Best Buy"
        
        let store2 = Store(entity: storeDescription!, insertInto: context)
        store2.name = "Lamborghini Dealership"
        
        let store3 = Store(entity: storeDescription!, insertInto: context)
        store3.name = "Frys Electronics"
        
        let store4 = Store(entity: storeDescription!, insertInto: context)
        store4.name = "Target"
        
        let store5 = Store(entity: storeDescription!, insertInto: context)
        store5.name = "Amazon"
        
        let store6 = Store(entity: storeDescription!, insertInto: context)
        store6.name = "K Mart"
        
        let store7 = Store(entity: storeDescription!, insertInto: context)
        store7.name = "HyperOne"
        
        ad.saveContext() //then save it
    }
    func generateTypeTestData() {
        let itemTypeDescription = NSEntityDescription.entity(forEntityName: "ItemType", in: context)
        let itemType = ItemType(entity: itemTypeDescription!, insertInto: context)
        itemType.type = "Food"
        
        let itemType2 = ItemType(entity: itemTypeDescription!, insertInto: context)
        itemType2.type = "Automotive"
        
        let itemType3 = ItemType(entity: itemTypeDescription!, insertInto: context)
        itemType3.type = "Electronics"
        
        let itemType4 = ItemType(entity: itemTypeDescription!, insertInto: context)
        itemType4.type = "Accessories"
        
        let itemType5 = ItemType(entity: itemTypeDescription!, insertInto: context)
        itemType5.type = "Clothes"
        
        ad.saveContext()
    }
    

}
