//
//  Item+CoreDataClass.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 12/4/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import Foundation
import CoreData


public class Item: NSManagedObject {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }
}
