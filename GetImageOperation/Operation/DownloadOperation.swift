//
//  DownloadOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit

final class DownloadOperation: Operation, @unchecked Sendable {
    
    var target: PhotoData
    
    init(target: PhotoData) {
        self.target = target
        super.init()
    }
    
    override func main() {
        print(target.url, "START")
        
        defer {
            if isCancelled {
                print(target.url, "Cancelled")
            } else {
                print(target.url, "DONE")
            }
        }
        
        guard !Thread.isMainThread else {
            fatalError("다운로드를 메인쓰레드에서 사용하려 함")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        do {
            
            let binaryImageData = try Data(contentsOf: target.url)
            guard let image = UIImage(data: binaryImageData) else {
                fatalError("이미지 변환 실패")
            }
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            let imageSize: CGSize = image.size.applying(CGAffineTransform(scaleX: 0.33, y: 0.33))
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            let frame: CGRect = CGRect(origin: .zero, size: imageSize)
            
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
