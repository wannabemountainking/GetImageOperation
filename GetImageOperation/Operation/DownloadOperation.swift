//
//  DownloadOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit

class DownloadOperation: Operation, @unchecked Sendable {
    
    var target: PhotoData
    
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
            fatalError()
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        do {
            
            let binaryImageData = try Data(contentsOf: target.url)
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            guard let image = UIImage(data: binaryImageData) else {
                fatalError()
            }
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            let imageSize = image.size.applying(CGAffineTransform(scaleX: 0.3, y: 0.3))
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            let frame = CGRect(origin: .zero, size: imageSize)
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            image.draw(in: frame)
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            UIGraphicsEndImageContext()
            
            target.data = resultImage
            
        } catch {
            print(target, error.localizedDescription)
        }
    }
    
    override func cancel() {
        super.cancel()
        print(target.url, "Cancel")
    }
}
