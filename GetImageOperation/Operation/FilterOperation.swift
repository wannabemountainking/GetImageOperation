//
//  FilterOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit


class FilterOperation: Operation, @unchecked Sendable {
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
                print(target.url,"Done")
            }
        }
        
        guard !Thread.isMainThread else {
            fatalError()
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let source = target.data?.cgImage else {
            fatalError()
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        let ciImage = CIImage(cgImage: source)
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectNoir")
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage else {
            fatalError()
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        guard let cgImage = context.createCGImage(ciResult, from: ciResult.extent) else {
            fatalError()
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
