//
//  YCRefreshBackFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshBackFooter: YCRefreshFooter {

    private var lastRefreshCount: Int = 0
    private var lastBottomDelta: CGFloat = 0
        
    override open var state: YCRefresh.State {
        didSet {
            guard let scrollView = self.scrollView else {
                return
            }
            
            if state == .noMoreData || state == .idle {
                if oldValue == .refreshing {
                    UIView.animate(withDuration: YCRefreshConst.slowAnimationDuration, animations: {
                        self.endRefreshingAnimationBeginAction?()
                        scrollView.yc.insetBottom -= self.lastBottomDelta

                        if self.automaticallyChangeAlpha {
                            self.alpha = 0.0
                        }
                    }) { (_) in
                        self.pullingPercent = 0.0
                        
                        self.endRefreshingCompletionBlock?()
                    }
                }
                
                let deltaHeight = heightForContentBreakView()
                if oldValue == .refreshing, deltaHeight > 0, scrollView.yc.totalDataCount != lastRefreshCount {
                    scrollView.yc.offsetY = scrollView.yc.offsetY
                }

            } else if state == .refreshing {
                lastRefreshCount = scrollView.yc.totalDataCount
                
                UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration, animations: {
                    var bottom = self.yc.height + self.scrollViewOriginalInset.bottom
                    let deltaHeight = self.heightForContentBreakView()
                    if deltaHeight < 0 {
                        bottom -= deltaHeight
                    }
                    self.lastBottomDelta = bottom - scrollView.yc.insetBottom
                    scrollView.yc.insetBottom = bottom
                    scrollView.yc.offsetY = self.getHappenOffsetY() + self.yc.height
                }) { (_) in
                    self.executeRefreshingCallback()
                }
            }
        }
    }
    
    open override func prepare() {
        super.prepare()
        
        automaticallyChangeAlpha = true
    }
    
    override public func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        scrollViewContentSizeDidChange(nil)
    }
    
    open override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        guard let scrollView = scrollView else {
            return
        }
        
        yc.x = scrollView.contentOffset.x + scrollView.yc.insetLeft
        
        guard state != .refreshing else {
            return
        }
        
        scrollViewOriginalInset = scrollView.yc.inset
        let currentOffsetY = scrollView.yc.offsetY
        let happenOffsetY = getHappenOffsetY()
        if currentOffsetY <= happenOffsetY {
            return
        }
        let pullingPercent = (currentOffsetY - happenOffsetY) / yc.height
        if state == .noMoreData {
            self.pullingPercent = pullingPercent
        }
        
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            let normalPullingOffsetY = happenOffsetY + yc.height
            if state == .idle, currentOffsetY > normalPullingOffsetY {
                state = .pulling
            } else if state == .pulling, currentOffsetY <= normalPullingOffsetY {
                state = .idle
            }
        } else if state == .pulling {
            beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
    
    open override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        guard let scrollView = scrollView else {
            return
        }
        let contentHeight = scrollView.yc.contentHeight + ignoredScrollViewContentInsetBottom
        let scrollHeight = scrollView.yc.height - scrollViewOriginalInset.top - scrollViewOriginalInset.bottom + ignoredScrollViewContentInsetBottom
        yc.y = max(contentHeight, scrollHeight)
    }
    
    private func getHappenOffsetY() -> CGFloat {
        let deltaHeight = heightForContentBreakView()
        if deltaHeight > 0 {
            return deltaHeight - scrollViewOriginalInset.top
        } else {
            return -scrollViewOriginalInset.top
        }
    }
    
    private func heightForContentBreakView() -> CGFloat {
        guard let scrollView = scrollView else {
            return 0.0
        }
        let height = scrollView.yc.height - scrollViewOriginalInset.bottom - scrollViewOriginalInset.top
        return scrollView.contentSize.height - height
    }

}
