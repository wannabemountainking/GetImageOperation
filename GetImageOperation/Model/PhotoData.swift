//
//  PhotoData.swift
//  GetImageOperation
//
//  Created by YoonieMac on 12/19/24.
//

import UIKit

final class PhotoData {
    
    let url: URL
    var data: UIImage?
    
    init(urlString: String) {
        self.url = URL(string: urlString)!
    }
}
