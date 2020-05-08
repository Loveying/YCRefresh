//
//  YCRefreshHeader.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshHeader: YCRefreshComponent {

    /// 创建 Refresh Header
    /// - Parameter block: 回调
    public class func header(WithRefreshing block: @escaping YCRefreshComponentAction) -> YCRefreshHeader {
        let header = self.init()
        header.refreshingBlock = block
        return header
    }
    
    /// 创建 Refresh Header
    /// - Parameter block: 回调
    public convenience init(withRefreshing block: @escaping YCRefreshComponentAction) {
        self.init()
        self.refreshingBlock = block
    }
    
    /// 创建 Refresh Header
    /// - Parameters:
    ///   - target: 回调目标
    ///   - action: 回调方法
    public class func header(withRefreshing target: NSObject?, action: Selector?) -> YCRefreshHeader {
        let header = self.init()
        header.setRefreshing(target: target, action: action)
        return header
    }
    
    /// 创建 Refresh Header
    /// - Parameters:
    ///   - target: 回调目标
    ///   - action: 回调方法
    public convenience init(withRefreshing target: NSObject?, action: Selector?) {
        self.init()
        self.setRefreshing(target: target, action: action)
    }
    
    // MARK: -
    
    open var lastUpdatedTimeKey: String = YCRefreshHeaderConst.lastUpdateTimeKey
    open var lastUpdatedTime: Date? {
        return UserDefaults.standard.object(forKey: lastUpdatedTimeKey) as? Date
    }
    
    /// 忽略 Scroll View 的 Content Inset 顶部距离
    open var ignoredScrollViewContentInsetTop: CGFloat = 0 {
        didSet {
            self.yc.y = -self.yc.height - ignoredScrollViewContentInsetTop
        }
    }
    
    
    
    override open var state: YCRefresh.State {
        didSet {
            guard let scrollView = self.scrollView else {
                return
            }
            
            switch state {
            case .idle:
                if oldValue != .refreshing {
                    return
                }
                UserDefaults.standard.set(Date(), forKey: lastUpdatedTimeKey)
                UserDefaults.standard.synchronize()
                                
                scrollView.isUserInteractionEnabled = false
                
                UIView.animate(withDuration: YCRefreshConst.slowAnimationDuration, animations: {
                    scrollView.yc.insetTop += self.insetTDelta
                    if self.automaticallyChangeAlpha {
                        self.alpha = 0.0
                    }
                }) { (_) in
                    scrollView.isUserInteractionEnabled = true
                    self.pullingPercent = 0.0
                    self.endRefreshingCompletionBlock?()
                }
            case .refreshing:
                if scrollView.panGestureRecognizer.state == .cancelled {
                    self.executeRefreshingCallback()
                    return
                }
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    
                    scrollView.isUserInteractionEnabled = false
                    
                    UIView.animate(withDuration: YCRefreshConst.fastAnimationDuration, animations: {
                        let top = self.scrollViewOriginalInset.top + self.yc.height
                        scrollView.yc.insetTop = top
                        var offset = scrollView.contentOffset
                        offset.y = -top
                        scrollView.setContentOffset(offset, animated: false)
                    }) { (_) in
                        scrollView.isUserInteractionEnabled = true
                        self.executeRefreshingCallback()
                    }
                }
            default:
                break
            }
        }
    }
    
    // MARK: -
    
    private var insetTDelta: CGFloat = 0
    
    override open func prepare() {
        super.prepare()
        autoresizingMask = .flexibleWidth

        yc.height = YCRefreshConst.headerHeight
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        
        yc.y = -yc.height - ignoredScrollViewContentInsetTop
        
        if let scrollView = scrollView {
            if #available(iOS 11.0, *) {
                yc.width = scrollView.yc.safeAreaWidth
            } else {
                yc.width = scrollView.yc.width
            }
        }
    }
    
    public override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        guard let scrollView = self.scrollView else {
            return
        }
        
        /// 打开垂直方向弹簧效果
        scrollView.alwaysBounceVertical = true
        /// 记录 Scroll View 初始 Inset
        scrollViewOriginalInset = scrollView.yc.inset
    }
    
    open override func scrollViewContentOffsetDidChange(_ change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change)
        
        guard let scrollView = self.scrollView else { return }
        
        yc.x = scrollView.contentOffset.x + scrollView.yc.insetLeft
        
        if self.state == .refreshing {
            
            var insetTop = max(-scrollView.yc.offsetY, scrollViewOriginalInset.top)
            insetTop = min(insetTop, yc.height + scrollViewOriginalInset.top)
            scrollView.yc.insetTop = insetTop
            insetTDelta = scrollViewOriginalInset.top - insetTop
            
            return
        }
        
        scrollViewOriginalInset = scrollView.yc.inset
        
        let offsetY = scrollView.yc.offsetY
        let happenOffsetY = -scrollViewOriginalInset.top
        
        if offsetY > happenOffsetY {
            return
        }
        
        // 普通 和 即将刷新 的临界点
        let normalPullingOffsetY = happenOffsetY - yc.height
        let pullingPercent = (happenOffsetY - offsetY) / yc.height
        // 如果正在拖拽
        if scrollView.isDragging {
            self.pullingPercent = pullingPercent
            if self.state == .idle && offsetY < normalPullingOffsetY {
                // 转为即将刷新状态
                self.state = .pulling
            } else if self.state == .pulling && offsetY >= normalPullingOffsetY {
                // 转为普通状态
                self.state = .idle
            }
        } else if self.state == .pulling { // 即将刷新 && 手松开
            //开始刷新
            self.beginRefreshing()
        } else if pullingPercent < 1 {
            self.pullingPercent = pullingPercent
        }
    }
}
