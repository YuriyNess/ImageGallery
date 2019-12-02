//
//  OperationChaining.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/2/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

precedencegroup OperationChaining {
    associativity: left
}
infix operator ==> : OperationChaining

@discardableResult
func ==><T: Operation>(lhs: T, rhs: T) -> T {
    rhs.addDependency(lhs)
    return rhs
}
