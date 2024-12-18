//
//  FilterOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit

class FilterOperation: Operation, @unchecked Sendable {
    
    var target: PhotoData
    var context = CIContext(options: nil)
    
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
                print(target.url, "Done")
            }
        }
        
        guard !Thread.isMainThread else {
            fatalError("FilterOperation이 mainThread에서 작동하려고 합니다.")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let source = target.data?.cgImage else {
            fatalError("CGImage로 변환 실패")
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
        
        guard let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage else {
            fatalError("필터가 적용된 CIImage변환 실패")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let cgImage = context.createCGImage(ciResult, from: ciResult.extent) else {
            fatalError("필터 적용 CGImage 변환 실패")
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
