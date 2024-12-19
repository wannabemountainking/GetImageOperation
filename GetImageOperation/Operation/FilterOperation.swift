//
//  FilterOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit

final class FilterOperation: Operation, @unchecked Sendable {
    
    var target: PhotoData
    let context = CIContext(options: nil)
    
    init(target: PhotoData) {
        self.target = target
        super.init()
    }
    
    override func main() {
        print(target.url, "Start")
        
        defer {
            if isCancelled {
                print(target.url, "Cancelled")
            } else {
                print(target.url, "DONE")
            }
        }
        
        guard !Thread.isMainThread else {
            fatalError("필터오퍼레이션은 메인스레드에서 실행되어선 안됩니다.")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let source = target.data?.cgImage else {
            fatalError("cgImage 변환 실패")
        }
        let ciImage = CIImage(cgImage: source)
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let ci = filter?.value(forKey: kCIOutputImageKey), let ciResult = ci as? CIImage else {
            fatalError("필터 입힌 ciimage 변환 실패")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let cgImage = context.createCGImage(ciResult, from: ciResult.extent) else {
            fatalError("context를 사용하여 ciImage => cgImage 변환 실패")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        target.data = UIImage(cgImage: cgImage)
    }
    
    override func cancel() {
        super.cancel()
        print(target.url, "Cancel")
    }
}
