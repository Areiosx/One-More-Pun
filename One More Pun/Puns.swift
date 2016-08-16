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
        Pun(body: "Did you hear about the guy that was frozen to absolute zero? He's 0k now."),
        Pun("Did you hear about the guy that was frozen to absolute zero? He's 0k now."),
        Pun("I'd tell you about my broken pencil collection, but it's pointless"                //submitted by tom p),
        Pun("If you forget how to throw a boomerang, it'll come back to you"),
        Pun("Grammar is so much more than Grampar's wife."),
        Pun("Some guy just threw cheese at me. How dairy!"),
        Pun("There's a network in Australia called a LAN down under."),
        Pun("50 Cent and Nickleback in concert? I wouldn't go if it only cost $.45!"),
        Pun("I usually take steps to avoid elevators."),
        Pun("Santa's helpers? You mean subordinate Clauses."),
        Pun("\"I'll never sleep on the railroad tracks again!\" Tom said, beside himself."),
        Pun("Prisoners love punctuation because of the period. It's the end of a sentence."),
        Pun("Have you been to that new body shop? It's highly wreck-a-mended."),
        Pun("When the neutron went to pay his tab the barkeep said, \"For you? No charge!\""),
        Pun("Without geometry, life is pointless."),
        Pun("\"I unclogged the drain with a vacuum cleaner,\" Tom said succinctly."),
        Pun("A relief map is where you find the restrooms."),
        Pun("I was going too tell you a joke about sodium and hydrogen, but NaH.",              //submitted by jordan b
        "My favorite song about chemistry is Alkaline Dubstep. I love when he drops the bass.",
        "Whoever discovered zero: thanks for nothing!",
        "I need to find a new brand of diapers for my kid. These ones are so crappy.",      //submitted by lia g
        "Witches' parking only. All others will be toad.",
        "Have you heard of that new band Cellophane? They mostly wrap.",                    //submitted by lia g
        "I wasn't originally going to get a brain transplant, but then I changed my mind.",
        "I wondered why the baseball was getting bigger. Then it hit me.",
        "Did you hear about the guy whose whole left side was cut off? He's all right now.",
        "A friend of mine tried to annoy me with bird puns, but I soon realized that toucan play at that game."
        
        
    ]
    
    func randomPun() -> Pun {
        let randomNumber  = Int(arc4random_uniform(UInt32(punsArray.count)))
        return punsArray[randomNumber]
    }
    
}