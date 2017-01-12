//
//  MaterialView.swift
//  DreamLister (Udemy) wishlist
//
//  Created by Mahmoud Hamad on 11/15/16.
//  Copyright © 2016 Mahmoud SMGL. All rights reserved.
//

import UIKit

private var materialKey: Bool = false // initial false, we can't create it in the extention
//by default it won't be selecting the material design option for these

extension UIView {

    @IBInspectable var materialDesign: Bool {     // something we can select on storyboard
    
        get {
            return materialKey
            
        }
        set {
            materialKey = newValue // when someone goes in and add new value it will set the private
        
            if materialKey { // if it's true
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                self.layer.shadowColor = UIColor(red: 157/255, green: 157/255, blue: 157/255, alpha: 1.0).cgColor
                // all the property for shadow so it look nice
            
            } else { // its not then
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.shadowRadius = 0.0
                self.layer.shadowColor = nil
                
            }
        }
    }

}
