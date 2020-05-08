//
//  YCRefreshFooter.swift
//  YCRefreshDemo
//
//  Created by Codyy.YY on 2020/5/8.
//  Copyright © 2020 Codyy.YY. All rights reserved.
//

import UIKit

open class YCRefreshFooter: YCRefreshComponent {

    /// 创建 Refresh Footer
    /// - Parameter block: 回调
    public class func footer(withRefreshing block: @escaping YCRefreshComponentAction) -> YCRefreshFooter {
        let footer = self.init()
        footer.refreshingBlock = block
        return footer
    }
    
    /// 创建 Refresh Footer
    /// - Parameter block: 回调
    public convenience init(withRefreshing block: @escaping YCRefreshComponentAction) {
        self.init()
        self.refreshingBlock = block
    }
    
    /// 创建 Refresh Footerr
    /// - Parameters:
    ///   - target: 回调目标
    ///   - action: 回调方法
    public class func footer(withRefreshing target: NSObject?, action: Selector?) -> YCRefreshFooter {
        let footer = self.init()
        footer.setRefreshing(target: target, action: action)
        return footer
    }
    
    /// 创建 Refresh Footerr
    /// - Parameters:
    ///   - target: 回调目标
    ///   - action: 回调方法
    public convenience init(withRefreshing target: NSObject?, action: Selector?) {
        self.init()
        self.setRefreshing(target: target, action: action)
    }
    
    // MARK: -
    
    /// 忽略 Scroll View 的 Content Inset 底部距离
    public var ignoredScrollViewContentInsetBottom: CGFloat = 0
    
    override open func prepare() {
        super.prepare()
        autoresizingMask = .flexibleWidth

        yc.height = YCRefreshConst.footerHeight
    }
    
    open override func placeSubviews() {
        super.placeSubviews()
        
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
    
    public func endRefreshingWithNoMoreData(completion block: (() -> Void)? = nil) {
        
        endRefreshingCompletionBlock = block
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.state = .noMoreData
        }
    }
    
    public func resetNoMoreData() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.state = .idle
        }
    }

}
