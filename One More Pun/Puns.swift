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
        Pun(body: "I'd tell you about my broken pencil collection, but it's pointless"),                //submitted by tom p
        Pun(body: "If you forget how to throw a boomerang, it'll come back to you"),
        Pun(body: "Grammar is so much more than Grampar's wife."),
        Pun(body: "Some guy just threw cheese at me. How dairy!"),
        Pun(body: "There's a network in Australia called a LAN down under."),
        Pun(body: "50 Cent and Nickleback in concert? I wouldn't go if it only cost $.45!"),
        Pun(body: "I usually take steps to avoid elevators."),
        Pun(body: "Santa's helpers? You mean subordinate Clauses."),
        Pun(body: "\"I'll never sleep on the railroad tracks again!\" Tom said, beside himself."),
        Pun(body: "Prisoners love punctuation because of the period. It's the end of a sentence."),
        Pun(body: "Have you been to that new body shop? It's highly wreck-a-mended."),
        Pun(body: "When the neutron went to pay his tab the barkeep said, \"For you? No charge!\""),
        Pun(body: "Without geometry, life is pointless."),
        Pun(body: "\"I unclogged the drain with a vacuum cleaner,\" Tom said succinctly."),
        Pun(body: "A relief map is where you find the restrooms."),
        Pun(body: "I was going too tell you a joke about sodium and hydrogen, but NaH."),               //submitted by jordan b
        Pun(body: "My favorite song about chemistry is Alkaline Dubstep. I love when he drops the bass."),
        Pun(body: "Whoever discovered zero: thanks for nothing!"),
        Pun(body: "I need to find a new brand of diapers for my kid. These ones are so crappy."),      //submitted by lia g
        Pun(body: "Witches' parking only. All others will be toad."),
        Pun(body: "Have you heard of that new band Cellophane? They mostly wrap."),                    //submitted by lia g
        Pun(body: "I wasn't originally going to get a brain transplant, but then I changed my mind."),
        Pun(body: "I wondered why the baseball was getting bigger. Then it hit me."),
        Pun(body: "Did you hear about the guy whose whole left side was cut off? He's all right now."),
        Pun(body: "A friend of mine tried to annoy me with bird puns, but I soon realized that toucan play at that game."),
        
        
    ]
    
    func randomPun() -> Pun {
        let randomNumber  = Int(arc4random_uniform(UInt32(punsArray.count)))
        return punsArray[randomNumber]
    }
    
}