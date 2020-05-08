//
//  YCChiBaoZiAutoFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

class YCChiBaoZiAutoFooter: YCRefreshAutoGifFooter {
    
    override func prepare() {
        super.prepare()
        
        var refreshingImages: [UIImage] = []
        for i in 1 ... 3 {
            let image = UIImage(named: "dropdown_loading_0\(i)") ?? UIImage()
            refreshingImages.append(image)
        }        
        setImages(refreshingImages, for: .refreshing)
    }

}
