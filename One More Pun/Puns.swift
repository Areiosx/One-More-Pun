//
//  Puns.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 12/6/15.
//  Copyright © 2015 Areios. All rights reserved.
//

import Foundation

struct Puns {
    let punsArray = [
        "Did you hear about the guy that was frozen to absolute zero? He's 0k now.",
        "I'd tell you about my broken pencil collection, but it's pointless",               //submitted by tom p
        "If you forget how to throw a boomerang, it'll come back to you",
        "Grammar is so much more than Grampar's wife.",
        "Some guy just threw cheese at me. How dairy!",
        "There's a network in Australia called a LAN down under.",
        "I went to the 50 Cent and Nickleback concert. It was only 45 cents.",
        "I usually take steps to avoid elevators.",
        "Santa's helpers? You mean subordinate Clauses.",
        "\"I'll never sleep on the railroad tracks again!\" Tom said, beside himself.",
        "Prisoners love punctuation because of the period. It's the end of a sentence.",
        "Have you been to that new body shop? It's highly wreck-a-mended.",
        "When the neutron went to pay his tab the barkeep said, \"For you? No charge!\"",
        "Without geometry, life is pointless.",
        "\"I unclogged the drain with a vacuum cleaner,\" Tom said succinctly.",
        "A relief map is where you find the restrooms.",
        "I was going too tell you a joke about sodium and hydrogen, but NaH.",              //submitted by jordan b
        "My favorite song about chemistry is Alkaline Dubstep. I love when he drops the bass.",
        "Whoever discovered zero: thanks for nothing!",
        "I need to find a new brand of diapers for my kid. These ones are so crappy.",      //submitted by lia g
        "Witches' parking only. All others will be toad.",
        "Have you heard of that new band Cellophane? They mostly wrap.",                    //submitted by lia g
    ]
    
    func randomPun() -> String {
        let randomNumber  = Int(arc4random_uniform(UInt32(punsArray.count)))
        return punsArray[randomNumber]
    }
    
}