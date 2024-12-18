//
//  DownloadOperation.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit

class DownloadOperation: Operation, @unchecked Sendable {
    
    var target: PhotoData
    
    var imageData: UIImage?
    
    init(target: PhotoData, imageData: UIImage? = nil) {
        self.target = target
        self.imageData = imageData
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
            fatalError("Download가 mainThread에서 진행되려고 했습니다.")
        }
        
        guard !isCancelled else {
            print(target.url, "Cancelled")
            return
        }
        
        do {
            
            let imageData = try Data(contentsOf: target.url)
            guard let image = UIImage(data: imageData) else {
                fatalError("이미지 데이터 변환에 실패했습니다.")
            }
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            // 이미지 크기 1/3 축소
            let imageSize = image.size.applying(CGAffineTransform(scaleX: 0.3, y: 0.3))
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            //그림 틀을 만들고(UIGraphicsBeginImageContextWithOptions()) 이미지를 그 안에 다시 그림
            UIGraphicsBeginImageContextWithOptions(imageSize, false, 0.0)
            let frame = CGRect(origin: .zero, size: imageSize)
            
            guard !isCancelled else {
                print(target.url, "Cancelled")
                return
            }
            
            image.draw(in: frame)
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
