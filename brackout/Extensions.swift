//
//  Extensions.swift
//  brackout
//
//  Created by Daniil Pimenau on 08-06-16.
//  Copyright © 2016 Daniil Pimenau. All rights reserved.
//

import Foundation

extension String {
    func `repeat`(n:Int) -> String {
        if n <= 0 { return "" }
        
        var result = self
        for _ in 1 ..< n { result += self }
        return result
    }
}

extension Array {
    func find(includedElement: Element -> Bool) -> Int? {
        for (idx, element) in self.enumerate() {
            if includedElement(element) {
                return idx
            }
        }
        return nil
    }
}