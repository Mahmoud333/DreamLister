//
//  ItemCell.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 11/15/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {

    @IBOutlet weak var thumb: UIImageView! // the image
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var details: UILabel!
    // description offen sometimes reserved keyword 
    //so don't use description when u name this things it might mess something up

    func configureCell(_ item: Item) { //takes Item (entity) put them in cell outlets
        
        self.title.text = item.title
        self.price.text = "$\(item.price!.doubleValue)"
        self.details.text = item.details
        //Image Here
        self.thumb.image = item.toImage?.image as? UIImage
    }
    

}
