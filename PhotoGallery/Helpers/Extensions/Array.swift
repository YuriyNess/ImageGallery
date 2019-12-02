//
//  Array.swift
//  EasyTraining
//
//  Created by YuriyFpc on 10/23/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

extension Array where Element: Equatable {
    func index(element: Element) -> Int? {
        for (index,item) in enumerated() {
            if item == element {
                return index
            }
        }
        return nil
    }
}

extension Array where Element: Equatable {
    func index(closure: (Element)->Bool) -> Int? {
        for (index,item) in enumerated() {
            if closure(item) {
                return index
            }
        }
        return nil
    }
    
    func element(closure: (Element)->Bool) -> Element? {
        for (_,item) in enumerated() {
            if closure(item) {
                return item
            }
        }
        return nil
    }
}
