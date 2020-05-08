//
//  YCRefreshNormalHeader.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshNormalHeader: YCRefreshStateHeader {

    private(set) lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage.loadImage(named: "arrow"))
        return imageView
    }()
    
    private(set) lazy var loadingView: UIActivityIndicatorView = {
        var style = UIActivityIndicatorView.Style.gray
        if #available(iOS 13.0, *) {
            style = UIActivityIndicatorView.Style.medium
        }
        let view = UIActivityIndicatorView(style: style)
        return view
    }()
    
    override open func prepare() {
        super.prepare()
        addSubview(arrowView)
        addSubview(loadingView)
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        var arrowCenterX = yc.width * 0.5
        if !stateLabel.isHidden {
            let stateWidth = stateLabel.yc.textWidth
            var timeWidth: CGFloat = 0.0
            if !lastUpdatedTimeLabel.isHidden {
                timeWidth = lastUpdatedTimeLabel.yc.textWidth
            }
            let textWidth = max(stateWidth, timeWidth)
            arrowCenterX -= textWidth / 2 + labelLeftInset
        }
        
        let arrowCenterY = yc.height * 0.5
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY)
        
        if arrowView.constraints.count == 0 {
            arrowView.yc.size = arrowView.image?.size ?? CGSize.zero
            arrowView.center = arrowCenter
        }
        
        if loadingView.constraints.count == 0 {
            loadingView.center = arrowCenter
        }
        
        arrowView.tintColor = stateLabel.textColor
    }
    
    override open var state: YCRefresh.State {
        didSet {
            if state == .idle {
                if oldValue == .refreshing {
                    arrowView.transform = .identity
                    
                    UIView.animate(withDuration: YCRefreshConst.slowAnimationDuration, animations: {
                        self.loadingView.alpha = 0.0
                    }) { (_) in
                        if self.state != .idle {
                            return
                        }
                        self.loadingView.alpha = 1.0
                        self.loadingView.stopAnimating()
                        self.arrowView.isHidden = false
                    }
                } else {
                    loadingView.stopAnimating()
                    arrowView.isHidden = false
                    UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration) {
                        self.arrowView.transform = .identity
                    }
                }
            } else if state == .pulling {
                loadingView.stopAnimating()
                arrowView.isHidden = false
                UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration) {
                    self.arrowView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                }
            } else if state == .refreshing {
                loadingView.alpha = 1.0
                loadingView.startAnimating()
                arrowView.isHidden = true
            }
        }
    }

}
