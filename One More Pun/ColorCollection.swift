//
//  Colors.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import Foundation
import UIKit

struct ColorCollection {
    let colorsArray = [
        UIColor(red:85/255.0, green: 145/255.0, blue: 170/255.0, alpha: 1.0),   // teal
        UIColor(red:222/255.0, green: 171/255.0, blue: 66/255.0, alpha: 1.0),   // yellow
        UIColor(red:214/255.0, green: 41/255.0, blue: 32/255.0, alpha: 1.0),    // red
        UIColor(red:234/255.0, green: 110/255.0, blue: 31/255.0, alpha: 1.0),   // orange
        UIColor(red:91/255.0, green: 103/255.0, blue: 117/255.0, alpha: 1.0),   // dark
        UIColor(red:47/255.0, green: 24/255.0, blue: 70/255.0, alpha: 1.0),     // purple
        UIColor(red:67/255.0, green: 146/255.0, blue: 73/255.0, alpha: 1.0),    // green
        UIColor(red:150/255.0, green: 40/255.0, blue: 27/255.0, alpha: 1.0),    // old brick
        UIColor(red:210/255.0, green: 77/255.0, blue: 87/255.0, alpha: 1.0),    // chestnut rose
        UIColor(red:154/255.0, green: 18/255.0, blue: 179/255.0, alpha: 1.0),   // seance
        UIColor(red:103/255.0, green: 65/255.0, blue: 114/255.0, alpha: 1.0),   // honey flower
        UIColor(red:191/255.0, green: 85/255.0, blue: 236/255.0, alpha: 1.0),   // medium purple
        UIColor(red:25/255.0, green: 181/255.0, blue: 154/255.0, alpha: 1.0),   // dodger blue
        UIColor(red:51/255.0, green: 110/255.0, blue: 123/255.0, alpha: 1.0),   // ming
        UIColor(red:34/255.0, green: 49/255.0, blue: 63/255.0, alpha: 1.0),     // ebony clay
        UIColor(red:107/255.0, green: 185/255.0, blue: 240/255.0, alpha: 1.0),  // malibu
        UIColor(red:37/255.0, green: 116/255.0, blue: 169/255.0, alpha: 1.0),   // jelly bean
        UIColor(red:78/255.0, green: 205/255.0, blue: 196/255.0, alpha: 1.0),   // medium turquoise
        UIColor(red:3/255.0, green: 201/255.0, blue: 169/255.0, alpha: 1.0),    // caribbean green
        UIColor(red:101/255.0, green: 198/255.0, blue: 187/255.0, alpha: 1.0),  // downy
        UIColor(red:249/255.0, green: 105/255.0, blue: 14/255.0, alpha: 1.0),   // ecstacy
        UIColor(red:211/255.0, green: 84/255.0, blue: 0/255.0, alpha: 1.0),     // burnt orange
        UIColor(red:248/255.0, green: 148/255.0, blue: 6/255.0, alpha: 1.0),    // california
        UIColor(red:34/255.0, green: 51/255.0, blue: 55/255.0, alpha: 1.0),     // indigo
        UIColor(red:24/255.0, green: 62/255.0, blue: 83/255.0, alpha: 1.0),     // hanada
        UIColor(red:74/255.0, green: 155/255.0, blue: 124/255.0, alpha: 1.0),   // sky
        
    ]
    
    func randomColor() -> UIColor {
        let unsignedArrayCount = UInt32(colorsArray.count)
        let unsignedRandomNumber = arc4random_uniform(unsignedArrayCount)
        let randomNumber = Int(unsignedRandomNumber)
        
        return colorsArray[randomNumber]
    }
    
}
