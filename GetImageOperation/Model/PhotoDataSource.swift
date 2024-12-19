//
//  PhotoDataSource.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit


final class PhotoDataSource {
    
    var list = [PhotoData]()
    
    init() {
        var list = [PhotoData]()
        for num in 1...20 {
            let urlString = "https://kxcodingblob.blob.core.windows.net/mastering-ios/\(num).jpg"
            list.append(PhotoData(urlString: urlString))
        }
        
        self.list = list
    }
}
