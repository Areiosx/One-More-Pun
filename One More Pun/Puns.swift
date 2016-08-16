//
//  Puns.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import Foundation

struct Puns {
    var punsArray: [Pun] = [
        Pun(body: "No puns right now. Tap the + to submit one!")
    ]
    
    func randomPun() -> Pun {
        let randomNumber  = Int(arc4random_uniform(UInt32(punsArray.count)))
        return punsArray[randomNumber]
    }
    
}