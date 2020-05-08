//
//  YCRefreshBackNormalFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshBackNormalFooter: YCRefreshBackStateFooter {

    private(set) lazy var arrowView: UIImageView = {
        let imageView = UIImageView(image: UIImage.loadImage(named: "arrow"))
        imageView.transform = .init(rotationAngle: CGFloat.pi)
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
        
        var arrowCenterX = yc.width * 0.5;
        if !stateLabel.isHidden {
            arrowCenterX -= labelLeftInset + stateLabel.yc.textWidth * 0.5;
        }
        let arrowCenterY = yc.height * 0.5;
        let arrowCenter = CGPoint(x: arrowCenterX, y: arrowCenterY);
        
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
                    arrowView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
                    
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
                    arrowView.isHidden = false
                    loadingView.stopAnimating()
                    
                    UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration) {
                        self.arrowView.transform = CGAffineTransform(rotationAngle: -CGFloat.pi)
                    }
                }
            } else if state == .pulling {
                arrowView.isHidden = false
                
                self.loadingView.stopAnimating()
                UIView.animate(withDuration:YCRefreshConst.fastAnimationDuration) {
                    self.arrowView.transform = .identity
                }
            } else if state == .refreshing {
                arrowView.isHidden = true
                loadingView.startAnimating()
            } else if state == .noMoreData {
                arrowView.isHidden = true
                loadingView.stopAnimating()
            }
        }
    }

}
