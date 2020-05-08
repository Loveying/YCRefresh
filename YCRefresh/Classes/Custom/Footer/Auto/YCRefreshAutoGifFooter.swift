//
//  YCRefreshAutoGifFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshAutoGifFooter: YCRefreshAutoStateFooter {

    private(set) lazy var gifView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    public func setImages(_ images: [UIImage], duration: TimeInterval? = nil, for state: YCRefresh.State) {
        guard images.count > 0 else {
            return
        }
        
        var duration = duration
        if duration == nil {
            duration = Double(images.count) * 0.1
        }
        
        stateImages[state] = images
        stateDurations[state] = duration
        
        let image = images.first!
        if image.size.height > yc.height {
            yc.height = image.size.height
        }
    }
    
    private var stateImages: [YCRefresh.State: [UIImage]] = [:]
    private var stateDurations: [YCRefresh.State: TimeInterval] = [:]
    
    open override func prepare() {
        super.prepare()
        addSubview(gifView)
        
        labelLeftInset = 20
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        
        if gifView.constraints.count != 0 {
            return
        }
        
        gifView.frame = bounds;
        
        if refreshingTitleHidden {
            gifView.contentMode = .center;
        } else {
            gifView.contentMode = .right;
            
            gifView.yc.width = yc.width * 0.5 - labelLeftInset - stateLabel.yc.textWidth * 0.5
        }
    }
    
    open override var state: YCRefresh.State {
        didSet {
            
            if state == .refreshing {
                guard let images = stateImages[state], images.count != 0 else {
                    return
                }
                gifView.stopAnimating()
                
                gifView.isHidden = false
                if images.count == 1 {
                    gifView.image = images.last!
                } else {
                    gifView.animationImages = images
                    gifView.animationDuration = stateDurations[state] ?? Double(images.count) * 0.1
                    gifView.startAnimating()
                }
            } else if state == .idle || state == .noMoreData {
                gifView.stopAnimating()
                gifView.isHidden = true
            }
        }
    }

}
