//
//  YCRefreshAutoNormalFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshAutoNormalFooter: YCRefreshAutoStateFooter {

    private(set) lazy var loadingView: UIActivityIndicatorView = {
        var style = UIActivityIndicatorView.Style.gray
        if #available(iOS 13.0, *) {
            style = UIActivityIndicatorView.Style.medium
        }
        let view = UIActivityIndicatorView(style: style)
        return view
    }()
    
    open override func prepare() {
        super.prepare()
        addSubview(loadingView)
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        
        if loadingView.constraints.count != 0 {
            return
        }
        
        var loadingCenterX = yc.width * 0.5;
        if !refreshingTitleHidden {
            loadingCenterX -= stateLabel.yc.textWidth * 0.5 + labelLeftInset;
        }
        let loadingCenterY = yc.height * 0.5;
        loadingView.center = CGPoint(x: loadingCenterX, y: loadingCenterY)
    }
    
    open override var state: YCRefresh.State {
        didSet {
            if state == .noMoreData || state == .idle {
                loadingView.stopAnimating()
            } else if state == .refreshing {
                loadingView.startAnimating()
            }
        }
    }

}
