//
//  YCChiBaoZiBackFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

class YCChiBaoZiBackFooter: YCRefreshBackGifFooter {

    override func prepare() {
        super.prepare()
        
        var idleImages: [UIImage] = []
        for i in 1 ... 60 {
            let image = UIImage(named: "dropdown_anim__000\(i)") ?? UIImage()
            idleImages.append(image)
        }
        setImages(idleImages, for: .idle)
        
        var refreshingImages: [UIImage] = []
        for i in 1 ... 3 {
            let image = UIImage(named: "dropdown_loading_0\(i)") ?? UIImage()
            refreshingImages.append(image)
        }
        setImages(refreshingImages, for: .pulling)
        
        setImages(refreshingImages, for: .refreshing)
        
    }

}
