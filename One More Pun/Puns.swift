//
//  Puns.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import Foundation

struct Puns {
    var punsArray: [Pun] = []
    
    func randomPun() -> Pun {
        if punsArray.count == 0 {
            return Pun(body: "No puns right now. Go ahead and submit one!")
        } else {
            let randomNumber = Int(arc4random_uniform(UInt32(punsArray.count)))
            return punsArray[randomNumber]
        }
    }
}