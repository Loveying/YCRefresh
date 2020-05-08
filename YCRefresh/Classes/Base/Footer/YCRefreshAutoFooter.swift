//
//  YCRefreshAutoFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshAutoFooter: YCRefreshFooter {

    public var automaticallyRefresh: Bool = true
    
    public var triggerAutomaticallyRefreshPercent: CGFloat = 1.0
    
    public var autoTriggerTimes: Int = 1 {
        didSet {
            leftTriggerTimes = autoTriggerTimes
        }
    }
    
    private var triggerByDrag: Bool = false
    private var leftTriggerTimes: Int = 0
    
    override open var state: YCRefresh.State {
        didSet {
            guard let scrollView = self.scrollView else {
                return
            }
            
            if state == .refreshing {
                executeRefreshingCallback()
            } else if state == .noMoreData || state == .idle {
                if triggerByDrag {
                    if !unlimitedTrigger {
                        leftTriggerTimes -= 1
                    }
                    triggerByDrag = false
                }
                
                if oldValue == .refreshing {
                    if scrollView.isPagingEnabled {
                        var offset = scrollView.contentOffset
                        offset.y -= scrollView.yc.insetBottom
                        
                        UIView.animate(withDuration: YCRefreshConst.slowAnimationDuration, animations: {
                            scrollView.contentOffset = offset
                            self.endRefreshingAnimationBeginAction?()
                        }) { (_) in
                            self.endRefreshingCompletionBlock?()
                        }
                        return
                    }
                    
                    endRefreshingCompletionBlock?()
                }
            }
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        guard let scrollView = scrollView else {
            return
        }
        if newSuperview != nil {
            if !isHidden {
                scrollView.yc.insetBottom += yc.height
            }
            yc.y = scrollView.yc.contentHeight
        } else {
            if !isHidden {
                scrollView.yc.insetBottom -= yc.height
            }
        }
    }
    
    open override func scrollViewContentSizeDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change)
        guard let scrollView = scrollView else {
            return
        }
        yc.y = scrollView.yc.contentHeight + ignoredScrollViewContentInsetBottom
    }
    
    open override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        guard let scrollView = scrollView, let change = change else {
            return
        }
        
        yc.x = scrollView.contentOffset.x + scrollView.yc.insetLeft

        if state != .idle || !automaticallyRefresh || yc.y == 0 {
            return
        }
        
        if scrollView.yc.insetTop + scrollView.yc.contentHeight > scrollView.yc.height {
            if scrollView.yc.offsetY >= scrollView.yc.contentHeight - scrollView.yc.height + yc.height * triggerAutomaticallyRefreshPercent + scrollView.yc.insetBottom - yc.height {
                let old = change[.oldKey] as? CGPoint ?? CGPoint.zero
                let new = change[.newKey] as? CGPoint ?? CGPoint.zero
                if old.y <= new.y {
                    return
                }
                
                if scrollView.isDragging {
                    triggerByDrag = true
                }
                
                beginRefreshing()
            }
        }
    }
    
    open override func scrollViewPanStateDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewPanStateDidChange(change)
        
        guard state == .idle, let scrollView = scrollView else {
            return
        }
        
        let panState = scrollView.panGestureRecognizer.state
        
        switch panState {
        case .ended:
            if scrollView.yc.insetTop + scrollView.yc.contentHeight <= scrollView.yc.height {
                if scrollView.yc.offsetY >= -scrollView.yc.insetTop {
                    triggerByDrag = true
                    beginRefreshing()
                }
            } else {
                if scrollView.yc.offsetY >= scrollView.yc.contentHeight + scrollView.yc.insetBottom - scrollView.yc.height {
                    triggerByDrag = true
                    beginRefreshing()
                }
            }
        case .began:
            resetTriggerTimes()
        default:
            break
        }
    }
    
    private var unlimitedTrigger: Bool {
        return leftTriggerTimes == -1
    }
    
    public override func beginRefreshing(withCompletion block: (() -> Void)? = nil) {
        if triggerByDrag, leftTriggerTimes <= 0, !unlimitedTrigger {
            return
        }
        
        super.beginRefreshing(withCompletion: block)
    }
    
    func resetTriggerTimes() {
        leftTriggerTimes = autoTriggerTimes
    }
    
    override public var isHidden: Bool {
        willSet {
            if !isHidden, newValue {
                state = .idle
                
                scrollView?.yc.insetBottom -= yc.height
            } else if isHidden, !newValue {
                scrollView?.yc.insetBottom += yc.height
                
                yc.y = scrollView?.yc.contentHeight ?? 0
            }
        }
    }

}
