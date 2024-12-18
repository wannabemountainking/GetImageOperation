//
//  PhotoDataSource.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/18/24.
//

import UIKit


final class PhotoDataSource {
    var list = [PhotoData]()
    
    init() {
        var photoList = [PhotoData]()
        for num in 1...20 {
            let urlString = "https://kxcodingblob.blob.core.windows.net/mastering-ios/\(num).jpg"
            let photoData = PhotoData(urlString: urlString)
            photoList.append(photoData)
        }
        self.list = photoList
    }
}

