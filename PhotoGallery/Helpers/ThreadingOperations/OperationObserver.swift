//
//  OperationObserver.swift
//  PhotoGallery
//
//  Created by YuriyFpc on 12/2/19.
//  Copyright © 2019 YuriyFpc. All rights reserved.
//

import Foundation

class OperationObserver: NSObject {
    func addObservableOperation(_ operation: AsyncOperation) {
        operation.addObserver(self, forKeyPath:
            #keyPath(Operation.isFinished), options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard let key = keyPath else {
            return
        }
        
        switch key {
        case "finished":
            print("DONE")
        default:
            print("doing")
        }
    }
}
