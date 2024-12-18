//
//  ReloadOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit


class ReloadOperation: Operation, @unchecked Sendable {
    
    weak var collectionView: UICollectionView!
    var indexPath: IndexPath?
    
    init(collectionView: UICollectionView!, indexPath: IndexPath? = nil) {
        self.collectionView = collectionView
        self.indexPath = indexPath
        super.init()
    }
    
    override func main() {
        print(self, "Start")
        
        defer {
            if isCancelled {
                print(self, "Cancelled", indexPath)
            } else {
                print(self, "Done", indexPath)
            }
        }
        
        guard Thread.isMainThread else {
            fatalError("reloadOperation이 background thread 에서 진행되려고 합니다.")
        }
        
        guard !isCancelled else {
            print(self, "Cancelled", indexPath)
            return
        }
        
        if let indexPath {
            if collectionView.indexPathsForVisibleItems.contains(indexPath) {
                collectionView.reloadItems(at: [indexPath])
            }
        } else {
            collectionView.reloadData()
        }
    }
    
    override func cancel() {
        super.cancel()
        print(self, "Cancel")
    }
}
