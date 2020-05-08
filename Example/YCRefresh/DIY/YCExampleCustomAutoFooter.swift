//
//  YCExampleCustomAutoFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

class YCExampleCustomAutoFooter: YCRefreshAutoFooter {
    
    lazy var loadingView: UIActivityIndicatorView = {
        var style = UIActivityIndicatorView.Style.gray
        if #available(iOS 13.0, *) {
            style = UIActivityIndicatorView.Style.medium
        }
        let view = UIActivityIndicatorView(activityIndicatorStyle: style)
        return view
    }()
    
    override func prepare() {
        super.prepare()
        addSubview(loadingView)
    
        yc.height = 30
    }
    
    override func placeSubviews() {
        super.placeSubviews()
        
        loadingView.frame = bounds
    }
    
    override var state: YCRefresh.State {
        didSet {
            if state == .refreshing {
                loadingView.startAnimating()
            } else {
                loadingView.stopAnimating()
            }
        }
    }
    
    override var pullingPercent: CGFloat {
        didSet {
            loadingView.alpha = pullingPercent * 2
        }
    }
    
}
