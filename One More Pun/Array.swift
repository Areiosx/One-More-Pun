//
//  Array.swift
//  One More Pun
//
//  Created by Nicholas Laughter on 3/30/17.
//  Copyright © 2017 Areios. All rights reserved.
//

import Foundation

extension Array where Element: Equatable {
    mutating func remove(_ object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
}

extension Array where Element: FirebaseType {
    mutating func deleteFromFirebase() {
        for Element in self {
            Element.delete()
        }
    }
}
