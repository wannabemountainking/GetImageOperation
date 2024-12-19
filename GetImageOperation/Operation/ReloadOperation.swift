//
//  ReloadOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit


final class ReloadOperation: Operation, @unchecked Sendable {
    weak var collectionView: UICollectionView!
    var indexPath: IndexPath?
    
    init(collectionView: UICollectionView, indexPath: IndexPath? = nil) {
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
            fatalError("리로드오퍼레이션은 메인스레드에서 실행되어야 합니다")
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
            collectionView.reloadData() // indexPath가 nil인 경우는 첫 화면에서만 적용되므로 걍 데이터를 리로드하면 됨
        }
    }
    
    override func cancel() {
        super.cancel()
        print(self, "Cancel")
    }
}
