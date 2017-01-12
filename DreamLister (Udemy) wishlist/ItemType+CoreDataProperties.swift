//
//  ItemType+CoreDataProperties.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 12/4/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType");
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
