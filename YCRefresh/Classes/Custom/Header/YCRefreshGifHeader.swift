//
//  YCRefreshGifHeader.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshGifHeader: YCRefreshStateHeader {

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
    
    override open func prepare() {
        super.prepare()
        addSubview(gifView)
        
        labelLeftInset = 20
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        if self.gifView.constraints.count != 0 {
            return
        }
        
        gifView.frame = bounds
        
        if stateLabel.isHidden, lastUpdatedTimeLabel.isHidden {
            gifView.contentMode = .center
        } else {
            gifView.contentMode = .right
            
            let stateWidth = stateLabel.yc.textWidth
            var timeWidth: CGFloat = 0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.yc.textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            
            gifView.yc.width = yc.width * 0.5 - textWidth * 0.5 - labelLeftInset
        }
    }
    
    override open var pullingPercent: CGFloat {
        didSet {
            guard state == .idle, let images = stateImages[.idle], images.count != 0 else {
                return
            }
            gifView.stopAnimating()
            var index = Int(CGFloat(images.count) * pullingPercent)
            if index >= images.count {
                index = images.count - 1
            }
            gifView.image = images[index]
        }
    }
    
    override open var state: YCRefresh.State {
        didSet {
            if state == .pulling || state == .refreshing {
                guard let images = stateImages[state], images.count != 0 else {
                    return
                }
                gifView.stopAnimating()
                if images.count == 1 {
                    gifView.image = images.last
                } else {
                    gifView.animationImages = images
                    gifView.animationDuration = stateDurations[state] ?? Double(images.count) * 0.1
                    gifView.startAnimating()
                }
            } else if state == .idle {
                gifView.stopAnimating()
            }
        }
    }

}
